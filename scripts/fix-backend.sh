#!/bin/bash

# Backend Fix Script
# This script attempts to automatically fix common backend issues

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================="
echo "  Backend Auto-Fix Script"
echo "========================================="
echo ""

# Change to backend directory
if [ ! -f "server.js" ]; then
    if [ -d "backend" ]; then
        cd backend
        echo "Changed to backend directory"
    else
        echo -e "${RED}Error: Cannot find backend directory${NC}"
        exit 1
    fi
fi

# Fix 1: Install dependencies
echo -n "[1] Checking dependencies... "
if [ ! -d "node_modules" ] || [ $(ls node_modules 2>/dev/null | wc -l) -lt 10 ]; then
    echo -e "${YELLOW}Missing or incomplete${NC}"
    echo "   Installing dependencies..."
    rm -rf node_modules package-lock.json
    npm install --production
    echo -e "   ${GREEN}✓ Dependencies installed${NC}"
else
    echo -e "${GREEN}✓ OK${NC}"
fi

# Fix 2: Create .env file
echo -n "[2] Checking .env file... "
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}Missing${NC}"
    if [ -f "env.example" ]; then
        cp env.example .env
        echo -e "   ${GREEN}✓ Created .env from env.example${NC}"
        echo -e "   ${YELLOW}⚠ Please edit .env with your configuration${NC}"
    else
        echo -e "   ${RED}✗ env.example not found${NC}"
        echo "   Creating basic .env file..."
        cat > .env << EOF
PORT=3000
NODE_ENV=production
MONGODB_URI=mongodb://localhost:27017/movieticket
JWT_SECRET=$(openssl rand -base64 32)
JWT_EXPIRE=7d
CORS_ORIGIN=http://localhost:8080
EOF
        echo -e "   ${GREEN}✓ Created basic .env file${NC}"
    fi
else
    echo -e "${GREEN}✓ OK${NC}"
fi

# Fix 3: Check MongoDB service
echo -n "[3] Checking MongoDB... "
if systemctl is-active --quiet mongod 2>/dev/null; then
    echo -e "${GREEN}✓ Running${NC}"
else
    echo -e "${YELLOW}Not running${NC}"
    if command -v systemctl &> /dev/null; then
        echo "   Attempting to start MongoDB..."
        sudo systemctl start mongod 2>/dev/null && echo -e "   ${GREEN}✓ MongoDB started${NC}" || echo -e "   ${YELLOW}⚠ Could not start MongoDB (may need manual start)${NC}"
    else
        echo -e "   ${YELLOW}⚠ Systemctl not available (may be using Docker or Atlas)${NC}"
    fi
fi

# Fix 4: Free up port 3000
echo -n "[4] Checking port 3000... "
if sudo lsof -i :3000 &> /dev/null 2>&1; then
    PROCESS=$(sudo lsof -i :3000 2>/dev/null | grep LISTEN | awk '{print $2}' | head -1)
    echo -e "${YELLOW}In use (PID: $PROCESS)${NC}"
    read -p "   Kill process $PROCESS? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo kill -9 $PROCESS 2>/dev/null && echo -e "   ${GREEN}✓ Process killed${NC}" || echo -e "   ${YELLOW}⚠ Could not kill process${NC}"
    fi
else
    echo -e "${GREEN}✓ Available${NC}"
fi

# Fix 5: Fix permissions
echo -n "[5] Checking permissions... "
if [ -w "." ] && [ -r "server.js" ]; then
    echo -e "${GREEN}✓ OK${NC}"
else
    echo -e "${YELLOW}Fixing...${NC}"
    sudo chown -R $USER:$USER . 2>/dev/null || true
    chmod -R 755 . 2>/dev/null || true
    echo -e "   ${GREEN}✓ Permissions fixed${NC}"
fi

# Fix 6: Verify file structure
echo -n "[6] Checking file structure... "
MISSING=0
for dir in config models routes middleware; do
    if [ ! -d "$dir" ]; then
        MISSING=$((MISSING + 1))
    fi
done

if [ $MISSING -eq 0 ]; then
    echo -e "${GREEN}✓ OK${NC}"
else
    echo -e "${RED}✗ Missing directories${NC}"
    echo -e "   ${YELLOW}Please ensure all files are uploaded correctly${NC}"
fi

echo ""
echo "========================================="
echo -e "${GREEN}Fix Complete!${NC}"
echo "========================================="
echo ""
echo "Next steps:"
echo "  1. Edit .env file if needed:"
echo "     nano .env"
echo ""
echo "  2. Test backend:"
echo "     node server.js"
echo ""
echo "  3. If successful, start with PM2:"
echo "     pm2 start server.js --name movieticket-api"
echo "     pm2 save"
echo ""
echo "  4. Check logs:"
echo "     pm2 logs movieticket-api"
echo ""

