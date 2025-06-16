# Submission Reminder Shell Script Project

This project is a Bash-based submission reminder application designed to help track and remind students about assignment submissions and deadlines. It is a school assignment that demonstrates shell scripting, file management, and automation skills.

## Project Overview

The application manages a list of students and their assignment submission statuses. It allows users to:

- Set up a structured environment for tracking submissions.
- Update the assignment being tracked.
- Check which students have not submitted a specific assignment.
- Display reminders for pending submissions.

## Directory Structure

Upon running the setup, the script asks the user for their name and the main directory with name  `submission_reminder_{name}` contains the following is generated:

- `startup.sh` — Main entry point to run the reminder application.
- `app/reminder.sh` — Script that prints assignment info and checks for pending submissions.
- `modules/functions.sh` — Contains helper functions, especially for checking submissions.
- `assets/submissions.txt` — File listing students, assignments, and submission statuses.
- `config/config.env` — Configuration file storing the current assignment and days remaining.

## How It Works

1. **Environment Setup**  
   Run [`create_environment.sh`](create_environment.sh) to generate the project folder and all necessary files. You will be prompted for your name, which is used to personalize the directory name (e.g., `submission_reminder_victor`).

2. **Configuration**  
   The configuration file (`config/config.env`) contains variables such as the assignment name (`ASSIGNMENT`) and days remaining (`DAYS_REMAINING`). You can update the assignment name using [`copilot_shell_script.sh`](copilot_shell_script.sh), which also backs up the config file before making changes.

3. **Checking Submissions**  
   The main script [`startup.sh`](submission_reminder_victor/startup.sh) sources the configuration and helper functions, then runs [`app/reminder.sh`](submission_reminder_victor/app/reminder.sh).  
   - `reminder.sh` reads the config and calls the `check_submissions` function from [`functions.sh`](submission_reminder_victor/modules/functions.sh).
   - `check_submissions` scans `assets/submissions.txt` and prints reminders for students who have not submitted the current assignment.

4. **Updating Assignment**  
   Use [`copilot_shell_script.sh`](copilot_shell_script.sh) to change the assignment being tracked. This script:
   - Prompts for a new assignment name.
   - Updates `config.env` safely (with backup).
   - Optionally runs the application to check the new assignment's submission status.

## Usage

1. **Set up the environment:**
   ```sh
   ./create_environment.sh
   ```
2. **Change directory to your personalized folder:**
   ```sh
   cd submission_reminder_<yourname>
   ```
3. **Run the application:**
   ```sh
   ./startup.sh
   ```
4. **To update the assignment and check status:**
   ```sh
   ../copilot_shell_script.sh
   ```

## File Descriptions

- **create_environment.sh**: Sets up the project structure and initial files.
- **copilot_shell_script.sh**: Updates the assignment in the config and optionally runs the reminder.
- **startup.sh**: Main entry point for the reminder application.
- **app/reminder.sh**: Displays assignment info and checks for pending submissions.
- **modules/functions.sh**: Contains the `check_submissions` function.
- **assets/submissions.txt**: List of students, assignments, and their submission statuses.
- **config/config.env**: Stores assignment and deadline configuration.

## Example Output

```
Assignment: Shell Navigation
Days remaining to submit: 2 days
--------------------------------------------
Checking submissions in ./assets/submissions.txt
Reminder: Chinemerem has not submitted the Shell Navigation assignment!
Reminder: Divine has not submitted the Shell Navigation assignment!
Reminder: Victor has not submitted the Shell Navigation assignment!
```

## Notes

- The scripts are designed for Unix-like environments with Bash.
- The application is modular and can be extended for more features.
- Always use the provided scripts to update configuration to ensure backups are created.

---
This project demonstrates practical shell scripting for automation
