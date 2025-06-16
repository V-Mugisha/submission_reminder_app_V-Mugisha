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

# Function to createa file with content
create_file() {
	local file_path=$1
    	local content=$2
    	echo "$content" > "$file_path"
	check_success "Created file: $file_path"
}
