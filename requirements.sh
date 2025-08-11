#!/bin/bash
set -e

# Update package list
apt-get update -y

# Install Git
apt-get install -y git

# Install Node.js (LTS) & npm
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

# Install Python 3 and pip
apt-get install -y python3 python3-pip python3-venv
sudo apt install -y pkg-config libmysqlclient-dev default-libmysqlclient-dev build-essential


# Install MySQL Server (non-interactive mode)
DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

# Install Nginx
apt-get install -y nginx

# Enable & start services
systemctl enable mysql
systemctl start mysql
systemctl enable nginx
systemctl start nginx