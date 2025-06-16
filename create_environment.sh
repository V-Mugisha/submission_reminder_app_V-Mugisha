#!/bin/bash

# This script creates the directory structure and files for the submission reminder application

# Colors for output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions

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

# Function to create directory with error handling
create_directory() {
    local dir_path=$1
    if [ ! -d "$dir_path" ]; then
        mkdir -p "$dir_path"
        check_success "Created directory: $dir_path"
    else
        print_message "$YELLOW" "Directory already exists: $dir_path"
    fi
}


# Function to createa file with content
create_file() {
	local file_path=$1
    	local content=$2
    	echo "$content" > "$file_path"
	check_success "Created file: $file_path"
}

# Main script starts here
print_message "$BLUE" "=== Submission Reminder App Environment Setup ==="
echo

# Prompt user for their name
echo -n "Enter your name: "
read user_name

# Validate input
if [ -z "$user_name" ]; then
    print_message "$RED" "Error: Name cannot be empty!"
    exit 1
fi

# Remove spaces and special characters from name for directory
clean_name=$(echo "$user_name" | tr -d ' ' | tr '[:upper:]' '[:lower:]')

# Create main directory
main_dir="submission_reminder_${clean_name}"
print_message "$BLUE" "Creating environment for: $user_name"
print_message "$BLUE" "Directory name: $main_dir"
echo

# Check if main directory already exists
if [ -d "$main_dir" ]; then
    echo -n "Directory $main_dir already exists. Do you want to overwrite it? (y/n): "
    read overwrite
    if [ "$overwrite" != "y" ] && [ "$overwrite" != "Y" ]; then
        print_message "$YELLOW" "Setup cancelled by user."
        exit 0
    fi
    rm -rf "$main_dir"
    print_message "$YELLOW" "Removed existing directory"
fi

# Create main directory
create_directory "$main_dir"

# Create subdirectories
print_message "$BLUE" "Creating subdirectories..."
create_directory "$main_dir/app"
create_directory "$main_dir/modules"
create_directory "$main_dir/assets"
create_directory "$main_dir/config"

# Content for config.env
config_content='# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
'

# Content for reminder.sh
reminder_content='#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
'

# Content for functions.sh  
functions_content='#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is not submitted
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
'

# Content for submissions.txt with original + 5 additional students
submissions_content='
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Victor, Shell Navigation, not submitted
Derrick, Linux and IT Tools, submitted
Yannick, Self Leadership and Team Dynamics, not submitted
George, E-Lab, submitted
Deborah, Reflective Thinking, not submitted
'

# Content for startup.sh
startup_content='#!/bin/bash
# Startup script for submission reminder app

# Source configuration and functions
source config/config.env
source modules/functions.sh

echo "=== Submission Reminder App ==="
echo "Assignment: $ASSIGNMENT"
echo "Deadline: $DEADLINE"
echo

# Check current directory structure
if [ ! -f "assets/submissions.txt" ]; then
    echo "Error: submissions.txt not found!"
    exit 1
fi

if [ ! -f "app/reminder.sh" ]; then
    echo "Error: reminder.sh not found!"
    exit 1
fi

echo "Starting reminder application..."
echo

# Execute the main reminder script
./app/reminder.sh

echo
echo "Application execution completed."
'

# Create and populate files
print_message "$BLUE" "Creating and populating files..."

create_file "$main_dir/config/config.env" "$config_content"
create_file "$main_dir/app/reminder.sh" "$reminder_content"
create_file "$main_dir/modules/functions.sh" "$functions_content"
create_file "$main_dir/assets/submissions.txt" "$submissions_content"
create_file "$main_dir/startup.sh" "$startup_content"

# Make all .sh files executable
print_message "$BLUE" "Setting executable permissions for .sh files..."
find "$main_dir" -name "*.sh" -type f -exec chmod +x {} \;
check_success "Set executable permissions for all .sh files"

# Verify the structure
print_message "$BLUE" "Directory structure created:"
tree "$main_dir" 2>/dev/null || find "$main_dir" -type f | sort

echo
print_message "$GREEN" "=== Environment Setup Complete! ==="
print_message "$BLUE" "To test the application:"
print_message "$BLUE" "1. cd $main_dir"
print_message "$BLUE" "2. ./startup.sh"
echo

# Test if startup.sh works
print_message "$BLUE" "Testing startup script..."
cd "$main_dir"
if [ -x "./startup.sh" ]; then
    print_message "$GREEN" "startup.sh is executable and ready to run"
    echo "Would you like to test the application now? (y/n): "
    read test_now
    if [ "$test_now" = "y" ] || [ "$test_now" = "Y" ]; then
        echo
        print_message "$BLUE" "Running application test..."
        ./startup.sh
    fi
else
    print_message "$RED" "Warning: startup.sh is not executable"
fi

cd ..
print_message "$GREEN" "Setup script completed successfully!"
