#!/bin/bash

# copilot_shell_script.sh - Script to update assignment name and rerun submission check
# This script allows users to change the assignment name in config.env and check submission status

# Colors for output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if command was successful
check_success() {
    if [ $? -eq 0 ]; then
        print_message "$GREEN" "✓ $1"
    else
        print_message "$RED" "✗ Failed: $1"
        exit 1
    fi
}

# Function to find submission reminder directory
find_submission_directory() {
    local dirs=(submission_reminder_*)
    if [ ${#dirs[@]} -eq 0 ] || [ ! -d "${dirs[0]}" ]; then
        print_message "$RED" "Error: No submission_reminder_* directory found!"
        print_message "$YELLOW" "Please run create_environment.sh first to create the application environment."
        exit 1
    elif [ ${#dirs[@]} -gt 1 ]; then
        print_message "$YELLOW" "Multiple submission directories found:"
        for i in "${!dirs[@]}"; do
            echo "$((i+1)). ${dirs[i]}"
        done
        echo -n "Select directory number: "
        read selection
        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#dirs[@]}" ]; then
            echo "${dirs[$((selection-1))]}"
        else
            print_message "$RED" "Invalid selection!"
            exit 1
        fi
    else
        echo "${dirs[0]}"
    fi
}

# Function to validate assignment name input
validate_assignment_name() {
    local assignment_name="$1"
    if [ -z "$assignment_name" ]; then
        print_message "$RED" "Error: Assignment name cannot be empty!"
        return 1
    fi
    # Check for potentially problematic characters
    if [[ "$assignment_name" =~ [\"\'\\] ]]; then
        print_message "$YELLOW" "Warning: Assignment name contains special characters that might cause issues."
        echo -n "Continue anyway? (y/n): "
        read continue_choice
        if [ "$continue_choice" != "y" ] && [ "$continue_choice" != "Y" ]; then
            return 1
        fi
    fi
    return 0
}

# Function to backup config file
backup_config() {
    local config_file="$1"
    local backup_file="${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$config_file" "$backup_file"
    check_success "Created backup: $backup_file"
}

# Function to update assignment in config file
update_assignment() {
    local config_file="$1"
    local new_assignment="$2"
    
    # Create backup before making changes
    backup_config "$config_file"
    
    # Use sed to update the ASSIGNMENT value on line 2
    # Handle both quoted and unquoted values
    sed -i "2s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" "$config_file"
    check_success "Updated ASSIGNMENT in config file"
    
    # Verify the change was made
    local updated_value=$(grep "^ASSIGNMENT=" "$config_file" | head -1)
    print_message "$BLUE" "Updated assignment: $updated_value"
}

# Function to verify startup script exists and is executable
verify_startup_script() {
    local app_dir="$1"
    local startup_script="$app_dir/startup.sh"
    
    if [ ! -f "$startup_script" ]; then
        print_message "$RED" "Error: startup.sh not found in $app_dir"
        return 1
    fi
    
    if [ ! -x "$startup_script" ]; then
        print_message "$YELLOW" "Warning: startup.sh is not executable. Making it executable..."
        chmod +x "$startup_script"
        check_success "Made startup.sh executable"
    fi
    
    return 0
}

# Main script execution starts here
print_message "$BLUE" "=== Submission Reminder Copilot Script ==="
print_message "$BLUE" "This script updates the assignment name and checks submission status"
echo

# Find the submission reminder directory
print_message "$BLUE" "Searching for submission reminder directory..."
app_directory=$(find_submission_directory)
print_message "$GREEN" "Found directory: $app_directory"

# Define paths
config_file="$app_directory/config/config.env"
startup_script="$app_directory/startup.sh"

# Check if config file exists
if [ ! -f "$config_file" ]; then
    print_message "$RED" "Error: Configuration file not found at $config_file"
    print_message "$YELLOW" "Please ensure the application environment is properly set up."
    exit 1
fi

# Display current assignment
print_message "$BLUE" "Current configuration:"
current_assignment=$(grep "^ASSIGNMENT=" "$config_file" | head -1)
print_message "$YELLOW" "$current_assignment"

# Prompt user for new assignment name
echo
print_message "$BLUE" "Enter the new assignment name:"
echo -n "Assignment name: "
read new_assignment_name

# Validate input
if ! validate_assignment_name "$new_assignment_name"; then
    print_message "$RED" "Operation cancelled due to invalid input."
    exit 1
fi

# Confirm the change
echo
print_message "$YELLOW" "You are about to change the assignment to: \"$new_assignment_name\""
echo -n "Continue? (y/n): "
read confirm_change

if [ "$confirm_change" != "y" ] && [ "$confirm_change" != "Y" ]; then
    print_message "$YELLOW" "Operation cancelled by user."
    exit 0
fi

# Update the assignment in config file
print_message "$BLUE" "Updating assignment in configuration file..."
update_assignment "$config_file" "$new_assignment_name"

# Verify startup script
print_message "$BLUE" "Verifying startup script..."
if ! verify_startup_script "$app_directory"; then
    exit 1
fi

