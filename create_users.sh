#!/bin/bash

# Script to create users, groups, and manage passwords securely

# Define log file and secure password file paths
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.csv"

# Function to create user and log actions
create_user() {
  username="$1"
  groups="$2"

  # Check if user already exists
  if id "$username" &> /dev/null; then
    echo "User '$username' already exists. Skipping..." >> "$LOG_FILE"
    return 1
  fi

  # Create user group with same name as username
  groupadd "$username" &>> "$LOG_FILE"

  # Create user with home directory and set ownership/permissions
  useradd -m -g "$username" -s /bin/bash "$username" &>> "$LOG_FILE"
  chown -R "$username:$username" "/home/$username" &>> "$LOG_FILE"
  chmod 700 "/home/$username" &>> "$LOG_FILE"

  # Generate random password
  password=$(head /dev/urandom | tr -dc A-Za-z0-9 | fold -w 16 | head -n 1)

  # Set user password
  echo "$username,$password" >> "$PASSWORD_FILE"  # Comma separated for CSV
  echo "$username" | passwd --stdin "$password" &>> "$LOG_FILE"

  # Add user to additional groups (comma separated)
  for group in $(echo "$groups" | tr ',' ' '); do
    usermod -a -G "$group" "$username" &>> "$LOG_FILE"
  done

  echo "User '$username' created successfully." >> "$LOG_FILE"
}

# Check if input file provided
if [ -z "$1" ]; then
  echo "Error: Please provide a text file containing usernames and groups as arguments."
  exit 1
fi

# Check and create log file with appropriate permissions (rw-r-----)
if [ ! -f "$LOG_FILE" ]; then
  touch "$LOG_FILE"
  chmod 640 "$LOG_FILE"
fi

# Check and create password file with restricted permissions (rw-------)
if [ ! -f "$PASSWORD_FILE" ]; then
  touch "$PASSWORD_FILE"
  chmod 600 "$PASSWORD_FILE"
fi

# Process user data from file line by line
while IFS=';' read -r username groups; do
  create_user "$username" "$groups"
done < "$1"

echo "User creation process complete. See log file '$LOG_FILE' for details."





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
