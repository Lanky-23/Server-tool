#!/bin/bash

# Script Name: devopsfetch.sh
# Description: A DevOps tool for system information retrieval and monitoring
# Author: [Your Name]

# Path to the monitor script
MONITOR_SCRIPT_PATH="/usr/local/bin/devopsfetch"

# Function to display help message
show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -p, --port [port_number]     Display active ports or detailed info about a specific port"
    echo "  -d, --docker [container_name] List Docker images/containers or detailed info about a specific container"
    echo "  -n, --nginx [domain]        Display Nginx domains or detailed config for a specific domain"
    echo "  -u, --users [username]      List all users and last login times or info about a specific user"
    echo "  -t, --time [time_range]     Display activities within a specified time range"
    echo "  -h, --help                  Show this help message and exit"
    echo "  --install-deps              Install necessary dependencies"
    echo "  --setup-service             Set up systemd service for continuous monitoring"
    echo "  --monitor                  Start continuous monitoring"
}

# Function to display active ports and services
display_ports() {
    if [ -z "$1" ]; then
        echo -e "\nActive Ports and Services:"
        echo "--------------------------"
        sudo netstat -tuln | awk 'NR>2 {printf "%-8s %-30s %-10s\n", $1, $4, $6}' | column -t
    else
        echo -e "\nDetailed Info for Port $1:"
        echo "--------------------------"
        sudo netstat -tuln | grep ":$1" | awk '{printf "%-8s %-30s %-10s\n", $1, $4, $6}' | column -t
    fi
}

# Function to display Docker images and containers
display_docker() {
    if [ -z "$1" ]; then
        echo -e "\nDocker Images:"
        echo "---------------"
        sudo docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}" | column -t
        echo ""
        echo -e "Docker Containers:"
        echo "-------------------"
        sudo docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.CreatedAt}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}" | column -t
    else
        echo -e "\nDocker Container Details for: $1"
        echo "---------------------------------"
        sudo docker inspect "$1" | jq . | less
    fi
}

# Function to display Nginx domains and ports
display_nginx() {
    if [ -z "$1" ]; then
        echo -e "\nNginx Domains and Ports:"
        echo "------------------------"
        sudo nginx -T | grep -E 'server_name|listen' | awk '{printf "%-20s %-10s\n", $1, $2}' | column -t
    else
        echo -e "\nNginx Config for Domain $1:"
        echo "----------------------------"
        sudo nginx -T | grep -A 10 "server_name .* $1" | awk '{printf "%-20s %-10s\n", $1, $2}' | column -t
    fi
}

# Function to list users and their last login times
display_users() {
    if [ -z "$1" ]; then
        echo -e "\nUsers and Last Login Times:"
        echo "---------------------------"
        lastlog | awk '{printf "%-15s %-20s %-15s\n", $1, $2, $3}' | column -t
    else
        echo -e "\nLast Login Info for User $1:"
        echo "------------------------------"
        lastlog | grep "$1" | awk '{printf "%-15s %-20s %-15s\n", $1, $2, $3}' | column -t
    fi
}

# Function to display activities within a time range
display_time() {
    if [ -z "$1" ]; then
        echo "Time range not specified."
    else
        echo -e "\nActivities from Time Range: $1"
        echo "------------------------------"
        # Add specific logic to filter logs or activities based on time range
    fi
}

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

# Function to monitor activities continuously
monitor_activities() {
    logfile="/var/log/devopsfetch/devopsfetch.log"
    echo "Starting continuous monitoring... Logs will be written to $logfile"

    while true; do
        echo -e "\n\n$(date)" >> $logfile
        echo "=== Active Ports ===" >> $logfile
        $0 -p >> $logfile
        echo -e "\n=== Docker Info ===" >> $logfile
        $0 -d >> $logfile
        echo -e "\n=== Nginx Info ===" >> $logfile
        $0 -n >> $logfile
        echo -e "\n=== User Info ===" >> $logfile
        $0 -u >> $logfile
        echo -e "\n=== Time-Based Activities ===" >> $logfile
        $0 -t >> $logfile
        sleep 60  # Adjust the sleep duration as needed
    done
}

# Parse command-line arguments
while [[ "$1" != "" ]]; do
    case $1 in
        -p|--port) shift; display_ports $1; exit ;;
        -d|--docker) shift; display_docker $1; exit ;;
        -n|--nginx) shift; display_nginx $1; exit ;;
        -u|--users) shift; display_users $1; exit ;;
        -t|--time) shift; display_time $1; exit ;;
        -h|--help) show_help; exit ;;
        --install-deps) install_dependencies; exit ;;
        --setup-service) setup_systemd_service; exit ;;
        --monitor) monitor_activities; exit ;;
        *) echo "Unknown option: $1"; show_help; exit 1 ;;
    esac
    shift
done

# Default action if no valid options are provided
show_help
exit 1
