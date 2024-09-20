#!/bin/bash

# Function to get public IP address
get_public_ip() {
    curl -s ifconfig.me
}

# Start code-server in the background
code-server --bind-addr 0.0.0.0:8080 &

# Wait for code-server to start
sleep 5

# Get the public IP address
public_ip=$(get_public_ip)

# Display information
echo "code-server is running on http://$public_ip:8080"
echo "Please ensure port 8080 is open on your firewall/router"
echo "Password can be found in ~/.config/code-server/config.yaml"

# Keep the script running
wait
