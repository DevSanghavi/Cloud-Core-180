#!/bin/bash
apt update
apt install -y nginx
systemctl start nginx
systemctl enable nginx
echo "<h1>Day 62: Automated with User Data!</h1>" > /var/www/html/index.nginx-debian.html
