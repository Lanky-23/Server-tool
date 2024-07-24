#!/bin/bash

# Script Name: setup_devopsfetch.sh
# Description: Sets up the necessary file paths, installs dependencies, and creates the systemd service for devopsfetch

# Function to install necessary dependencies
install_dependencies() {
    echo "Installing dependencies..."
    sudo apt-get update
    sudo apt-get install -y net-tools docker.io nginx util-linux
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo systemctl enable nginx
    sudo systemctl start nginx
}

# Function to copy scripts to appropriate locations
copy_scripts() {
    echo "Copying scripts..."
    sudo cp devopsfetch.sh /usr/local/bin/
    sudo chmod +x /usr/local/bin/devopsfetch.sh
}

# Function to set up systemd service
setup_systemd_service() {
    echo "Setting up systemd service..."
    cat <<EOF | sudo tee /etc/systemd/system/devopsfetch.service
[Unit]
Description=DevOps Fetch Monitoring Service
After=network.target

[Service]
ExecStart=/usr/local/bin/devopsfetch --monitor
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable devopsfetch.service
    sudo systemctl start devopsfetch.service
}

# Function to set up logging directory and file
setup_logging() {
    echo "Setting up logging directory and file..."
    sudo mkdir -p /var/log/devopsfetch
    sudo touch /var/log/devopsfetch/devopsfetch.log
    sudo chown $USER:$USER /var/log/devopsfetch/devopsfetch.log
}

# Run the setup functions
install_dependencies
copy_scripts
setup_logging
setup_systemd_service

echo "Installation completed. DevOpsFetch monitoring service is now running."
