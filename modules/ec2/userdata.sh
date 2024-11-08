#!/bin/bash
# Update packages
yum update -y

# Install necessary packages for EFS mounting
yum install -y amazon-efs-utils nfs-utils

# Create a directory to mount EFS
mkdir -p /var/www/html

# Mount EFS using the file system ID from Terraform
mount -t efs ${efs_id}:/ /var/www/html

# Make the mount persistent on reboot
echo "${efs_id}:/ /var/www/html efs defaults,_netdev 0 0" >> /etc/fstab

# Install Apache and PHP (if required for WordPress)
yum install -y httpd php

# Start and enable Apache on boot
systemctl start httpd
systemctl enable httpd

