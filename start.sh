#!/bin/bash

# Allow all incoming and outgoing traffic
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F

# Start SSH service
service ssh restart

# Authenticate Ngrok (Manually specify config path)
export NGROK_CONFIG=/tmp/ngrok.yml
ngrok authtoken 2lKjA15AAL3kFG0cbOpfTJGbewT_3PjMCSs55KCHQ2PKkoVdS --config $NGROK_CONFIG

# Start Ngrok to expose all ports
while true; do
    ngrok tcp 0.0.0.0:1-65535 --log=stdout --config $NGROK_CONFIG > /dev/null 2>&1
    sleep 2  # Restart delay in case of failure
done &

# Keep the container running
tail -f /dev/null
