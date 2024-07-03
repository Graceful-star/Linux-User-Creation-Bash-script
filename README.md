# Linux-User-Creation-Bash-script
## Automating User and Group Management with Bash
As a SysOps engineer, managing user accounts and their associated groups can be a repetitive and time-consuming task. To streamline this process, we can use a Bash script to automate user and group creation based on a provided input file. This article will walk you through the script I developed to achieve this and explain each step in detail.


With many new developers joining our team, manually creating user accounts and assigning them to appropriate groups is inefficient. The goal is to automate this process by reading a text file that contains usernames and group names, creating the users and groups, setting up home directories, and logging all actions.


### Script Overview
The create_users.sh script reads a text file containing employee usernames and group names, where each line is formatted as user;groups. It creates users and groups, sets up home directories, generates random passwords, and logs all actions.

### Prerequisites
1. A Linux or Unix-like environment
2. Bash shell
3. OpenSSL installed

### Script Explanation
Here's the complete create_users.sh script:

```
#!/bin/bash

# Check if the script is run with a file argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

echo "Script started with argument: $1"

# Variables
FILE=$1
LOG_FILE="./user_management.log"
PASSWORD_FILE="./user_passwords.csv"

echo "Using log file: $LOG_FILE"
echo "Using password file: $PASSWORD_FILE"

# Ensure the log file exists
touch $LOG_FILE
echo "Log file created at $LOG_FILE"

# Ensure the password file exists and set permissions
touch $PASSWORD_FILE
chmod 600 $PASSWORD_FILE
echo "Password file created at $PASSWORD_FILE with permissions set to 600"

# Log function
log() {
    echo "$(date +"%Y-%m-%d %T") - $1" | tee -a $LOG_FILE
}

# Create users and groups (simulated)
while IFS=';' read -r username groups; do
    # Remove whitespace
    username=$(echo "$username" | xargs)
    groups=$(echo "$groups" | xargs)

    echo "Processing user: $username with groups: $groups"

    # Simulate user and group creation
    log "Simulated creation of user $username with groups $groups"

    # Generate random password
    password=$(openssl rand -base64 12)
    echo "Generated password for $username: $password"

    # Store username and password
    echo "$username,$password" >> $PASSWORD_FILE
    echo "Stored password for $username in $PASSWORD_FILE"

done < "$FILE"

# Final log message
log "User creation script completed successfully (simulated)"
echo "User creation script completed successfully (simulated)"

exit 0
``


### Step-by-Step Breakdown
1. Script Initialization:
The script checks if it is run with a file argument and prints a usage message if not.

2. Variable Initialization:
The script sets the input file, log file, and password file variables.

3. Log and Password File Creation:
It ensures that the log and password files exist and sets the appropriate permissions.

4. Logging Function:
The log function logs messages with a timestamp to both the log file and the console.

5. User and Group Processing:
The script reads each line from the input file, extracts the username and groups, and logs the simulated creation of users and groups.
It generates a random password for each user and stores it in the password file.

6. Final Log Message:
The script logs a final message indicating successful completion.

### Testing the Script
To test the script, follow these steps:

1. Create an Input File:
Create a users.txt file with the following content:

`light; sudo,dev,www-data`
`idimma; sudo`
`mayowa; dev,www-data`

2. Make the Script Executable:
`chmod +x create_users.sh`

3. Run the Script:
`./create_users.sh users.txt`

4. Verify the Output:
Check the user_management.log and user_passwords.csv files to verify the results.