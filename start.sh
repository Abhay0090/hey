#!/bin/bash

# Start SSH service
service ssh restart

# Authenticate Ngrok (Replace with your actual Ngrok token)
ngrok authtoken 2lKjA15AAL3kFG0cbOpfTJGbewT_3PjMCSs55KCHQ2PKkoVdS

# Start Ngrok in a loop to keep it running
while true; do
    ngrok tcp 22 --log=stdout > /dev/null 2>&1
    sleep 2  # Restart delay in case of failure
done &

# Keep the container running
tail -f /dev/null
