#!/bin/bash

# Nginx Configuration Script for MovieTicket Application
# This script sets up Nginx as a reverse proxy

set -e

DOMAIN=$1
APP_PATH=$2

if [ -z "$DOMAIN" ] || [ -z "$APP_PATH" ]; then
    echo "Usage: ./setup-nginx.sh <domain-name> <app-path>"
    echo "Example: ./setup-nginx.sh example.com /home/ubuntu/movieticket"
    exit 1
fi

echo "Configuring Nginx for $DOMAIN..."

# Create Nginx configuration
sudo tee /etc/nginx/sites-available/movieticket > /dev/null <<EOF
upstream movieticket_api {
    server localhost:3000;
}

server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    
    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }
    
    location / {
        return 301 https://\$server_name\$request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN www.$DOMAIN;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    root $APP_PATH/frontend;
    index index.html;

    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/json application/javascript;

    location / {
        try_files \$uri \$uri/ /index.html;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    location /api {
        proxy_pass http://movieticket_api;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    location /metrics {
        allow 127.0.0.1;
        deny all;
        proxy_pass http://movieticket_api/metrics;
    }

    location /health {
        proxy_pass http://movieticket_api/health;
    }
}
EOF

# Enable site
sudo ln -sf /etc/nginx/sites-available/movieticket /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Test configuration
sudo nginx -t

echo "Nginx configuration created!"
echo ""
echo "Next steps:"
echo "  1. Setup SSL certificate: sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN"
echo "  2. Reload Nginx: sudo systemctl reload nginx"
echo ""

