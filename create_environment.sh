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
