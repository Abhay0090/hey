#!/bin/bash

# Allow all incoming and outgoing traffic
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -F

# Start SSH service (Needs sudo since we're not root)
sudo service ssh restart

# Authenticate Ngrok (Replace with your actual Ngrok token)
ngrok authtoken 2lKjA15AAL3kFG0cbOpfTJGbewT_3PjMCSs55KCHQ2PKkoVdS

# Start Ngrok to expose **all ports**
while true; do
    ngrok tcp 0.0.0.0:1-65535 --log=stdout > /dev/null 2>&1
    sleep 2  # Restart delay in case of failure
done &

# Keep the container running
tail -f /dev/null
