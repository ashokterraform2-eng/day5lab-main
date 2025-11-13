#!/bin/bash
set -euo pipefail

# Log all output for debugging
exec > /var/log/app_setup.log 2>&1

echo "---- App Setup Started9 ----"

# Ensure system packages
sudo yum update -y
sudo yum install -y python3 python3-pip

# Ensure ec2-user owns /home/ec2-user
sudo chown -R ec2-user:ec2-user /home/ec2-user

# Wait for NAT / Internet connectivity
echo "Waiting for internet connectivity..."
until curl -s https://pypi.org >/dev/null; do
  echo "No internet yet (NAT not ready). Retrying in 5s..."
  sleep 5
done
echo "Internet is available ✔"

# Retry Flask installation until success
echo "Installing Flask..."
for i in {1..10}; do
  if pip3 install --upgrade flask; then
    echo "Flask installed successfully ✔"
    break
  fi
  echo "Flask install failed. Retrying in 5s..."
  sleep 5
done

# Validate Flask import
python3 - << 'EOF'
import flask
print("✅ Flask import test successful")
EOF

# Create app directory
mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

# Create Flask application
cat << 'EOF' > /home/ec2-user/app/app.py
from flask import Flask, request
import socket

app = Flask(__name__)

@app.route('/')
def index():
    client_ip = request.remote_addr
    forwarded_by = request.headers.get('X-Forwarded-By', 'Direct-or-Unknown')
    return f"Hello from Application Tier on <b>{socket.gethostname()}</b><br><br>Request Source: {client_ip}<br>Forwarded By: {forwarded_by}"

@app.route('/health')
def health():
    return "healthy", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
EOF

# Permissions
sudo chown -R ec2-user:ec2-user /home/ec2-user/app

# Create systemd service
cat << 'EOF' | sudo tee /etc/systemd/system/flaskapp.service >/dev/null
[Unit]
Description=Flask App Service
Wants=network-online.target
After=network-online.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/app
ExecStart=/usr/bin/python3 /home/ec2-user/app/app.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Apply and start service
sudo systemctl daemon-reload
sudo systemctl enable flaskapp
sudo systemctl restart flaskapp

echo "---- App Setup Completed Successfully ----"
