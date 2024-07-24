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
`setup_devopsfetch.sh` is a Bash script that automates the setup process for devopsfetch.sh. It installs necessary dependencies, copies the main script to appropriate locations, creates a systemd service for continuous monitoring, and sets up logging for monitoring activities.

- Run the Setup Script:
```
./setup_devopsfetch.sh
```

## Dependencies
- `net-tools (for netstat)`
- `docker.io`
- `nginx`
- `util-linux`





### Usage
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
