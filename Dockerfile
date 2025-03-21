# Use a lightweight Ubuntu image
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Create a new user with a UID between 10000 and 20000
RUN useradd -m -d /home/samiruser -s /bin/bash -u 10014 samiruser && \
    echo "samiruser:samir090" | chpasswd

# Update and install necessary dependencies
RUN apt update && apt upgrade -y && \
    apt install -y openssh-server wget curl unzip iptables && \
    rm -rf /var/lib/apt/lists/*

# Allow SSH password authentication
RUN sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Download and install Ngrok
RUN wget -O /tmp/ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip && \
    unzip /tmp/ngrok.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/ngrok

# Copy the start script
COPY start.sh /home/samiruser/start.sh
RUN chmod +x /home/samiruser/start.sh

# Expose all ports
EXPOSE 0-65535

# Switch to the new user
USER 10014

# Run the start script
CMD ["/home/samiruser/start.sh"]
