#!/bin/bash

# Function to log messages
log() {
    echo "$(date +"%Y-%m-%d %T") - $1" | tee -a $LOG_FILE
}

# Check if the script is run with a file argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Variables
FILE=$1
LOG_FILE="./user_management.log"
PASSWORD_FILE="./user_passwords.csv"

# Ensure the log file exists
touch $LOG_FILE
chmod 600 $LOG_FILE

# Ensure the password file exists and set permissions
touch $PASSWORD_FILE
chmod 600 $PASSWORD_FILE

# Create users and groups
while IFS=';' read -r username groups; do
    # Remove whitespace
    username=$(echo "$username" | xargs)
    groups=$(echo "$groups" | xargs)

    # Check if the user already exists
    if id "$username" &>/dev/null; then
        log "User $username already exists, skipping creation"
        continue
    fi

    # Create user with a personal group
    if useradd -m -G "$username" "$username"; then
        log "Created user $username with home directory and personal group"
    else
        log "Failed to create user $username"
        continue
    fi

    # Add user to additional groups
    IFS=',' read -ra group_array <<< "$groups"
    for group in "${group_array[@]}"; do
        # Check if the group already exists
        if ! getent group "$group" &>/dev/null; then
            if groupadd "$group"; then
                log "Created group $group"
            else
                log "Failed to create group $group"
                continue
            fi
        fi
        if usermod -aG "$group" "$username"; then
            log "Added user $username to group $group"
        else
            log "Failed to add user $username to group $group"
        fi
    done

    # Generate random password
    password=$(openssl rand -base64 12)

    # Set the user's password
    echo "$username:$password" | chpasswd

    # Store username and password
    echo "$username,$password" >> $PASSWORD_FILE
done < "$FILE"

# Final log message
log "User creation script completed successfully"

exit 0




# #!/bin/bash

# # Check if the script is run with a file argument
# if [ "$#" -ne 1 ]; then
#     echo "Usage: $0 <filename>"
#     exit 1
# fi

# echo "Script started with argument: $1"

# # Variables
# FILE=$1
# LOG_FILE="./user_management.log"
# PASSWORD_FILE="./user_passwords.csv"

# echo "Using log file: $LOG_FILE"
# echo "Using password file: $PASSWORD_FILE"

# # Ensure the log file exists
# touch $LOG_FILE
# echo "Log file created at $LOG_FILE"

# # Ensure the password file exists and set permissions
# touch $PASSWORD_FILE
# chmod 600 $PASSWORD_FILE
# echo "Password file created at $PASSWORD_FILE with permissions set to 600"

# # Log function
# log() {
#     echo "$(date +"%Y-%m-%d %T") - $1" | tee -a $LOG_FILE
# }

# # Create users and groups (simulated)
# while IFS=';' read -r username groups; do
#     # Remove whitespace
#     username=$(echo "$username" | xargs)
#     groups=$(echo "$groups" | xargs)

#     echo "Processing user: $username with groups: $groups"

#     # Simulate user and group creation
#     log "Simulated creation of user $username with groups $groups"

#     # Generate random password
#     password=$(openssl rand -base64 12)
#     echo "Generated password for $username: $password"

#     # Store username and password
#     echo "$username,$password" >> $PASSWORD_FILE
#     echo "Stored password for $username in $PASSWORD_FILE"

# done < "$FILE"

# # Final log message
# log "User creation script completed successfully (simulated)"
# echo "User creation script completed successfully (simulated)"

# exit 0
