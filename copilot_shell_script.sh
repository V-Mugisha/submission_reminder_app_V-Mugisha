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

