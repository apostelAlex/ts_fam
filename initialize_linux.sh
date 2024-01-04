#!/bin/bash

# Set the SSH directory
SSH_DIR="$HOME/.ssh"

# Function to check for key pairs
check_for_key_pairs() {
    local found=0
    for key in "$SSH_DIR"/*; do
        if [[ -f $key && ! $key =~ \.pub$ ]]; then
            local pubkey="${key}.pub"
            if [[ -f $pubkey ]]; then
                echo "Found SSH key pair: $key and $pubkey"
                found=1
            fi
        fi
    done
    return $found
}

# Create the SSH directory if it doesn't exist
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Check for existing SSH key pairs
if check_for_key_pairs; then
    echo "SSH key pair already exists."
else
    # Generate a new SSH key pair
    echo "Generating a new SSH key pair..."
    local new_key="$SSH_DIR/id_ed25519"
    ssh-keygen -t ed25519 -f "$new_key" -N ""
    echo "New SSH key pair generated: $new_key and ${new_key}.pub"
fi

