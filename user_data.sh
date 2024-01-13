#!/bin/bash

# Update the system
sudo yum -y update

# Install Apache web server
sudo yum -y install httpd

# Start Apache web server
sudo systemctl start httpd.service

# Enable Apache to start at boot
sudo systemctl enable httpd.service

# Get the IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Retrieve instance metadata to get the private IPv4 DNS address
private_ipv4_dns=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-hostname)

# Create a simple HTML response with both private and public IPv4 DNS addresses
html_response="<html><body><h1>Private IPv4 DNS Address: $private_ipv4_dns</h1></body></html>"

# Save the HTML response to a file
echo "$html_response" > /var/www/html/index.html
