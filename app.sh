#!/bin/bash

# Update system packages
sudo yum update -y

# Install Apache HTTP Server
sudo yum install -y httpd

# Start Apache service
sudo systemctl start httpd

# Enable Apache to start on boot
sudo systemctl enable httpd

# Create a simple web page
echo "<h1>Hello from Terraform on port 80</h1>" | sudo tee /var/www/html/index.html

# Ensure Apache is running and listening on port 80
sudo systemctl status httpd