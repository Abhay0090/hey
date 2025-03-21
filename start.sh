#!/bin/bash

# Update and install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y openssh-server wget curl

# Set root password
echo "root:samir090" | sudo chpasswd

# Allow SSH password authentication
sudo sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Restart SSH service
sudo service ssh restart

# Download and install Ngrok
wget -O /tmp/ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip
unzip /tmp/ngrok.zip -d /usr/local/bin/
chmod +x /usr/local/bin/ngrok

# Start Ngrok with auto-restart
while true; do
    ngrok tcp 22 --log=stdout > /dev/null 2>&1
    sleep 2  # Short delay before restart if Ngrok crashes
done &

# Keep script running indefinitely
tail -f /dev/null
