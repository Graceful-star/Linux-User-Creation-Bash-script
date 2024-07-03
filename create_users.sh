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
