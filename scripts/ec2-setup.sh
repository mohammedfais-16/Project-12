#!/bin/bash

# EC2 Ubuntu Setup Script for MovieTicket Application
# Run this script on a fresh Ubuntu EC2 instance

set -e

echo "========================================="
echo "  MovieTicket EC2 Ubuntu Setup Script"
echo "========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}Please do not run as root. Use a regular user with sudo privileges.${NC}"
    exit 1
fi

# Update system
echo -e "${GREEN}[1/10] Updating system packages...${NC}"
sudo apt update
sudo apt upgrade -y

# Install essential tools
echo -e "${GREEN}[2/10] Installing essential tools...${NC}"
sudo apt install -y curl wget git vim unzip software-properties-common \
    apt-transport-https ca-certificates gnupg lsb-release build-essential

# Install Node.js
echo -e "${GREEN}[3/10] Installing Node.js...${NC}"
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

NODE_VERSION=$(node --version)
echo -e "${GREEN}Node.js installed: $NODE_VERSION${NC}"

# Install MongoDB
echo -e "${GREEN}[4/10] Installing MongoDB...${NC}"
echo "Choose MongoDB installation:"
echo "1) Local MongoDB Community Edition"
echo "2) Skip (will use MongoDB Atlas)"
read -p "Enter choice [1-2]: " mongo_choice

if [ "$mongo_choice" = "1" ]; then
    curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
    sudo apt update
    sudo apt install -y mongodb-org
    sudo systemctl start mongod
    sudo systemctl enable mongod
    echo -e "${GREEN}MongoDB installed and started${NC}"
else
    echo -e "${YELLOW}Skipping MongoDB installation. Make sure to use MongoDB Atlas.${NC}"
fi

# Install Docker (optional)
echo -e "${GREEN}[5/10] Installing Docker (optional)...${NC}"
read -p "Install Docker? (y/n): " install_docker

if [ "$install_docker" = "y" ] || [ "$install_docker" = "Y" ]; then
    sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker $USER
    echo -e "${GREEN}Docker installed. Log out and log back in for group changes.${NC}"
fi

# Install Nginx
echo -e "${GREEN}[6/10] Installing Nginx...${NC}"
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo -e "${GREEN}Nginx installed${NC}"

# Install PM2
echo -e "${GREEN}[7/10] Installing PM2...${NC}"
sudo npm install -g pm2
pm2 startup systemd | grep "sudo" || true
echo -e "${GREEN}PM2 installed${NC}"

# Setup firewall
echo -e "${GREEN}[8/10] Configuring firewall...${NC}"
sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
echo "y" | sudo ufw enable
echo -e "${GREEN}Firewall configured${NC}"

# Install Certbot for SSL
echo -e "${GREEN}[9/10] Installing Certbot...${NC}"
sudo apt install -y certbot python3-certbot-nginx
echo -e "${GREEN}Certbot installed${NC}"

# Install Fail2Ban
echo -e "${GREEN}[10/10] Installing Fail2Ban...${NC}"
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
echo -e "${GREEN}Fail2Ban installed${NC}"

# Display summary
echo ""
echo "========================================="
echo -e "${GREEN}Setup Complete!${NC}"
echo "========================================="
echo ""
echo "Installed components:"
echo "  ✅ Node.js: $(node --version)"
echo "  ✅ NPM: $(npm --version)"
echo "  ✅ MongoDB: $(mongod --version 2>/dev/null | head -n 1 || echo 'Not installed')"
echo "  ✅ Nginx: $(nginx -v 2>&1)"
echo "  ✅ PM2: $(pm2 --version)"
echo "  ✅ Docker: $(docker --version 2>/dev/null || echo 'Not installed')"
echo ""
echo "Next steps:"
echo "  1. Upload your application files"
echo "  2. Run: cd ~/movieticket/backend && npm install"
echo "  3. Configure .env file"
echo "  4. Run: npm run seed"
echo "  5. Start application with PM2 or systemd"
echo ""
echo "For detailed setup instructions, see:"
echo "  docs/EC2_UBUNTU_SETUP.md"
echo ""

