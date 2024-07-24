# DevOpsFetch Script and Setup Guide
## Table of Contents
### DevOpsFetch Script
- Overview
- Features
- Usage
- Command Line Options
- Examples
- Installation
- Dependencies
- Notes
- License
### Setup Script (setup_devopsfetch.sh)
- Overview
- Features
- Usage
- Notes
- License
## DevOpsFetch Script 
This is a Bash script designed for system information retrieval and monitoring in a DevOps environment. It provides various functionalities to gather and display information related to ports, Docker containers, Nginx configurations, user details, and more.

### Features 
- Display Active Ports: Shows active ports and services, optionally detailed info for a specific port.
- List Docker Information: Lists Docker images and containers, with detailed info for a specific container.
- Nginx Configuration: Displays Nginx domains and ports, detailed config for a specific domain.
- User Information: Lists all users and their last login times, or info about a specific user.
- Time-based Activities: Displays activities within a specified time range.
- Service Management: Installs necessary dependencies, sets up systemd service for continuous monitoring.

### Usage
Command Line Options 
```bash
C
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
Examples <a name="examples-devopsfetch"></a>
Display active ports:
bash
Copy code
./devopsfetch.sh --port
Display Docker images:
bash
Copy code
./devopsfetch.sh --docker
Display detailed Docker container info:
bash
Copy code
./devopsfetch.sh --docker [container_name]
Install dependencies:
bash
Copy code
./devopsfetch.sh --install-deps
Set up systemd service:
bash
Copy code
./devopsfetch.sh --setup-service
Start continuous monitoring:
bash
Copy code
./devopsfetch.sh --monitor
Installation <a name="installation-devopsfetch"></a>
Clone the repository:

bash
Copy code
git clone <repository_url>
cd <repository_directory>
Make the script executable:

bash
Copy code
chmod +x devopsfetch.sh
Dependencies <a name="dependencies-devopsfetch"></a>
net-tools (for netstat)
docker.io
nginx
util-linux
Ensure these dependencies are installed before running the script.

Notes <a name="notes-devopsfetch"></a>
Root Privileges: Some commands (sudo) in the script require root privileges. Ensure the script is executed with appropriate permissions.
Continuous Monitoring: When using --monitor, logs are written to /var/log/devopsfetch/devopsfetch.log.
License <a name="license-devopsfetch"></a>
This project is licensed under the MIT License.

Setup Script (setup_devopsfetch.sh) <a name="setup-script"></a>
Overview <a name="overview-setup"></a>
setup_devopsfetch.sh is a Bash script that automates the setup process for devopsfetch.sh. It installs necessary dependencies, copies the main script to appropriate locations, creates a systemd service for continuous monitoring, and sets up logging for monitoring activities.

Features <a name="features-setup"></a>
Installation of Dependencies: Installs required packages (net-tools, docker.io, nginx, util-linux) via apt-get.
Copying Scripts: Copies devopsfetch.sh to /usr/local/bin/ and sets executable permissions.
Systemd Service Setup: Configures a systemd service (devopsfetch.service) that runs devopsfetch.sh --monitor continuously, ensuring it restarts on failure.
Logging Setup: Establishes a logging directory (/var/log/devopsfetch/) and a log file (devopsfetch.log) to store monitoring logs.
Usage <a name="usage-setup"></a>
Installation Steps
Clone the Repository:

bash
Copy code
git clone <repository_url>
cd <repository_directory>
Navigate to the Script Directory:

bash
Copy code
cd <repository_directory>
Make the Script Executable:

bash
Copy code
chmod +x setup_devopsfetch.sh
Run the Setup Script:

bash
Copy code
./setup_devopsfetch.sh
Notes <a name="notes-setup"></a>
Permissions: Ensure the script is executed with sufficient permissions (sudo might be required for some operations like package installation and systemd configuration).
Continuous Monitoring: Once setup is complete, the devopsfetch service will start automatically and log activities to /var/log/devopsfetch/devopsfetch.log.
License <a name="license-setup"></a>
This project is licensed under the MIT License.

Feel free to customize the sections further based on your specific project details and user requirements. This combined README file provides a comprehensive guide for both using and setting up the DevOps monitoring tools using the devopsfetch.sh script and the setup_devopsfetch.sh setup script.
