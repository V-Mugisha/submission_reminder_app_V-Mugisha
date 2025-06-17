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

