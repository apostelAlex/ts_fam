#!/bin/zsh

# Set the SSH directory
SSH_DIR="$HOME/.ssh"

# Function to check for key pairs
check_for_key_pairs() {
    for private_key in "$SSH_DIR"/*; do
        if [[ -f $private_key && ! $private_key =~ \.pub$ ]]; then
            local public_key="${private_key}.pub"
            if [[ -f $public_key ]]; then
                echo "Found SSH key pair: $private_key and $public_key"
                copy_to_clipboard "$public_key"
                return 0
            fi
        fi
    done
    return 1
}

# Function to copy key to clipboard
copy_to_clipboard() {
    local public_key=$1
    # Check the OS and use the appropriate command to copy the key to the clipboard
    if command -v xclip > /dev/null; then
        xclip -selection clipboard < "$public_key"
        echo "Public key copied to clipboard."
    elif command -v pbcopy > /dev/null; then
        pbcopy < "$public_key"
        echo "Public key copied to clipboard."
    else
        echo "Clipboard functionality is not supported on this OS."
    fi
}

# Create the SSH directory if it doesn't exist
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Check for existing SSH key pairs
if ! check_for_key_pairs; then
    # Generate a new SSH key pair
    echo "Generating a new SSH key pair..."
    local new_key="$SSH_DIR/id_ed25519"
    ssh-keygen -t ed25519 -f "$new_key" -N ""
    echo "New SSH key pair generated: $new_key and ${new_key}.pub"
    copy_to_clipboard "${new_key}.pub"
else
    echo "Using existing SSH key pair."
fi
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8g0VMy1aedg41NhYWY1Zo0+MmZd/yyzObVS0q/FdaT ierosa2smix@gmail.com

# Function to extract username from SSH public key
extract_username_from_ssh_key() {
    local ssh_key=$1
    local username

    # Extract the last field which is usually the comment
    username=$(echo "$ssh_key" | awk '{print $NF}')

    echo "$username"
}

# Get the SSH public key from the clipboard
ssh_key=$(pbpaste)

# Check if the clipboard content is not empty
if [ -z "$ssh_key" ]; then
    echo "No SSH public key found in the clipboard."
    exit 1
fi

# Extract the username
username=$(extract_username_from_ssh_key "$ssh_key")

# Write to config.txt
{
    echo "A:$username"
} > config.txt

echo "Config file updated with username: $username"


