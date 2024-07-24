# DevOpsFetch Script and Setup Guide

## DevOpsFetch Script 
This is a Bash script designed for system information retrieval and monitoring in a DevOps environment. It provides various functionalities to gather and display information related to ports, Docker containers, Nginx configurations, user details, and more.

### Features 
- Display Active Ports: Shows active ports and services, optionally detailed info for a specific port.
- List Docker Information: Lists Docker images and containers, with detailed info for a specific container.
- Nginx Configuration: Displays Nginx domains and ports, detailed config for a specific domain.
- User Information: Lists all users and their last login times, or info about a specific user.
- Time-based Activities: Displays activities within a specified time range.
- Service Management: Installs necessary dependencies, sets up systemd service for continuous monitoring.

## Dependencies
- `net-tools (for netstat)`
- `docker.io`
- `nginx`
- `util-linux`

## Installation
- Clone the repository:
```
git clone <repo_url>
cd <repository_directory>
```
- Make the script executable:
```
chmod +x devopsfetch.sh
```

## Setup Script (setup_devopsfetch.sh)
`setup_devopsfetch.sh` is a Bash script that automates the setup process for `devopsfetch.sh`. It installs necessary dependencies, copies the main script to appropriate locations, creates a systemd service for continuous monitoring, and sets up logging for monitoring activities.
```
#!/bin/bash
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
```
- Make the Script Executable
 ```
 ./setup_devopsfetch.sh
 ```
- Run the Setup Script:
```
./setup_devopsfetch.sh
```
 
### Usage of the Devopsfetch Script
Command Line Options 
```bash
Usage: ./devopsfetch.sh [options]

Options:
  -p, --port [port_number]     Display active ports or detailed info about a specific port
  -d, --docker [container_name] List Docker images/containers or detailed info about a specific container
  -n, --nginx [domain]         Display Nginx domains or detailed config for a specific domain
  -u, --users [username]       List all users and last login times or info about a specific user
  -t, --time [time_range]      Display activities within a specified time range
  -h, --help                   Show this help message and exit
  --install-deps               Install necessary dependencies
  --setup-service              Set up systemd service for continuous monitoring
  --monitor                    Start continuous monitoring
```


## Examples
Display active ports:
```
./devopsfetch.sh --port
```

Display Docker images:
```
./devopsfetch.sh --docker
```

Display detailed Docker container info:
```
./devopsfetch.sh --docker [container_name]
```


Set up systemd service:
```
./devopsfetch.sh --setup-service
```
Start continuous monitoring:
```
./devopsfetch.sh --monitor
```


## More Information
- Root Privileges: Some commands (sudo) in the script require root privileges. Ensure the script is executed with appropriate permissions.
- Continuous Monitoring: When using --monitor, logs are written to /var/log/devopsfetch/devopsfetch.log.
- Logging Setup: Establishes a logging directory (/var/log/devopsfetch/) and a log file (devopsfetch.log) to store monitoring logs.
