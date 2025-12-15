#!/bin/bash

# Systemd Service Setup Script for MovieTicket API

set -e

APP_PATH=$1
USER=$2

if [ -z "$APP_PATH" ] || [ -z "$USER" ]; then
    echo "Usage: ./setup-systemd.sh <app-path> <user>"
    echo "Example: ./setup-systemd.sh /home/ubuntu/movieticket ubuntu"
    exit 1
fi

echo "Creating systemd service for MovieTicket API..."

# Create service file
sudo tee /etc/systemd/system/movieticket-api.service > /dev/null <<EOF
[Unit]
Description=MovieTicket API Service
After=network.target mongod.service

[Service]
Type=simple
User=$USER
WorkingDirectory=$APP_PATH/backend
Environment=NODE_ENV=production
EnvironmentFile=$APP_PATH/backend/.env
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=movieticket-api

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
sudo systemctl daemon-reload

# Enable service
sudo systemctl enable movieticket-api

echo "Systemd service created!"
echo ""
echo "Commands:"
echo "  Start:   sudo systemctl start movieticket-api"
echo "  Stop:    sudo systemctl stop movieticket-api"
echo "  Status:  sudo systemctl status movieticket-api"
echo "  Logs:    sudo journalctl -u movieticket-api -f"
echo ""

