# Use a lightweight Ubuntu image
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Create a non-root user with UID 10014 (Fix for CKV_CHOREO_1)
RUN useradd -m -d /home/samiruser -s /bin/bash -u 10014 samiruser && \
    echo "samiruser:samir090" | chpasswd

# Update and install necessary dependencies
RUN apt update && apt upgrade -y && \
    apt install -y openssh-server wget curl unzip iptables && \
    rm -rf /var/lib/apt/lists/*

# Allow SSH password authentication
RUN sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Start SSH service
RUN service ssh restart

# Download and install Ngrok
RUN wget -O /tmp/ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip && \
    unzip /tmp/ngrok.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/ngrok

# Authenticate Ngrok (Save config in /tmp to avoid filesystem issues)
ENV NGROK_CONFIG="/tmp/ngrok.yml"
RUN ngrok authtoken 2lKjA15AAL3kFG0cbOpfTJGbewT_3PjMCSs55KCHQ2PKkoVdS --config $NGROK_CONFIG

# 🔴 Run iptables BEFORE switching users to avoid permission issues
RUN iptables -P INPUT ACCEPT && \
    iptables -P OUTPUT ACCEPT && \
    iptables -P FORWARD ACCEPT && \
    iptables -F

# Expose all ports
EXPOSE 0-65535

# 🔵 Switch to non-root user AFTER running privileged commands
USER 10014

# Start SSH and Ngrok on container startup
CMD service ssh start && ngrok tcp 0.0.0.0:1-65535 --log=stdout --config $NGROK_CONFIG
