#!/bin/bash

# Backend Diagnostic Script
# Run this script to diagnose backend startup issues

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================="
echo "  Backend Diagnostic Check"
echo "========================================="
echo ""

# Change to backend directory
if [ ! -f "server.js" ]; then
    if [ -d "backend" ]; then
        cd backend
    else
        echo -e "${RED}✗ Error: Cannot find backend directory or server.js${NC}"
        echo "Please run this script from the project root or backend directory"
        exit 1
    fi
fi

ERRORS=0

# Check Node.js
echo -n "[1] Checking Node.js... "
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_MAJOR" -ge 18 ]; then
        echo -e "${GREEN}✓${NC} Node.js: $NODE_VERSION"
    else
        echo -e "${RED}✗${NC} Node.js version too old: $NODE_VERSION (Need v18+)"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "${RED}✗${NC} Node.js not installed"
    ERRORS=$((ERRORS + 1))
fi

# Check npm
echo -n "[2] Checking npm... "
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo -e "${GREEN}✓${NC} npm: $NPM_VERSION"
else
    echo -e "${RED}✗${NC} npm not installed"
    ERRORS=$((ERRORS + 1))
fi

# Check server.js
echo -n "[3] Checking server.js... "
if [ -f "server.js" ]; then
    echo -e "${GREEN}✓${NC} server.js exists"
else
    echo -e "${RED}✗${NC} server.js not found"
    ERRORS=$((ERRORS + 1))
fi

# Check package.json
echo -n "[4] Checking package.json... "
if [ -f "package.json" ]; then
    echo -e "${GREEN}✓${NC} package.json exists"
else
    echo -e "${RED}✗${NC} package.json not found"
    ERRORS=$((ERRORS + 1))
fi

# Check .env file
echo -n "[5] Checking .env file... "
if [ -f ".env" ]; then
    echo -e "${GREEN}✓${NC} .env file exists"
    
    # Check required variables
    if grep -q "MONGODB_URI" .env && grep -q "JWT_SECRET" .env; then
        echo -e "   ${GREEN}✓${NC} Required variables found"
    else
        echo -e "   ${YELLOW}⚠${NC} Some required variables may be missing"
    fi
else
    echo -e "${RED}✗${NC} .env file not found"
    echo -e "   ${YELLOW}Fix:${NC} cp env.example .env"
    ERRORS=$((ERRORS + 1))
fi

# Check node_modules
echo -n "[6] Checking dependencies... "
if [ -d "node_modules" ]; then
    MODULE_COUNT=$(ls node_modules 2>/dev/null | wc -l)
    if [ "$MODULE_COUNT" -gt 10 ]; then
        echo -e "${GREEN}✓${NC} node_modules exists ($MODULE_COUNT modules)"
    else
        echo -e "${YELLOW}⚠${NC} node_modules exists but may be incomplete"
        echo -e "   ${YELLOW}Fix:${NC} npm install"
    fi
else
    echo -e "${RED}✗${NC} node_modules not found"
    echo -e "   ${YELLOW}Fix:${NC} npm install"
    ERRORS=$((ERRORS + 1))
fi

# Check directory structure
echo -n "[7] Checking directory structure... "
MISSING_DIRS=0
for dir in config models routes middleware scripts; do
    if [ ! -d "$dir" ]; then
        MISSING_DIRS=$((MISSING_DIRS + 1))
    fi
done

if [ $MISSING_DIRS -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All required directories exist"
else
    echo -e "${YELLOW}⚠${NC} Some directories missing"
    ERRORS=$((ERRORS + 1))
fi

# Check MongoDB
echo -n "[8] Checking MongoDB service... "
if systemctl is-active --quiet mongod 2>/dev/null; then
    echo -e "${GREEN}✓${NC} MongoDB service is running"
elif command -v mongosh &> /dev/null || command -v mongo &> /dev/null; then
    echo -e "${YELLOW}⚠${NC} MongoDB installed but service may not be running"
    echo -e "   ${YELLOW}Fix:${NC} sudo systemctl start mongod"
else
    echo -e "${YELLOW}⚠${NC} MongoDB not detected (may be using Atlas)"
fi

# Test MongoDB connection
echo -n "[9] Testing MongoDB connection... "
if [ -f ".env" ]; then
    # Load environment variables
    export $(grep -v '^#' .env | xargs)
    
    # Try connection test
    node -e "
    require('dotenv').config();
    const mongoose = require('mongoose');
    const uri = process.env.MONGODB_URI || 'mongodb://localhost:27017/movieticket';
    mongoose.connect(uri, { serverSelectionTimeoutMS: 3000 })
      .then(() => { 
        console.log('OK'); 
        process.exit(0); 
      })
      .catch(err => { 
        console.log('FAILED: ' + err.message); 
        process.exit(1); 
      });
    " 2>&1 | grep -q "OK" && echo -e "${GREEN}✓${NC} Connection successful" || {
        echo -e "${RED}✗${NC} Connection failed"
        echo -e "   ${YELLOW}Check:${NC} MongoDB URI in .env and MongoDB service"
        ERRORS=$((ERRORS + 1))
    }
else
    echo -e "${YELLOW}⚠${NC} Cannot test (no .env file)"
fi

# Check port availability
echo -n "[10] Checking port 3000... "
if sudo lsof -i :3000 &> /dev/null 2>&1; then
    PROCESS=$(sudo lsof -i :3000 2>/dev/null | grep LISTEN | awk '{print $2}' | head -1)
    echo -e "${YELLOW}⚠${NC} Port 3000 is in use (PID: $PROCESS)"
    echo -e "   ${YELLOW}Fix:${NC} sudo kill -9 $PROCESS or change PORT in .env"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✓${NC} Port 3000 is available"
fi

# Check required files
echo -n "[11] Checking required files... "
MISSING_FILES=0
for file in "config/database.js" "models/User.js" "models/Movie.js" "routes/auth.js"; do
    if [ ! -f "$file" ]; then
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
done

if [ $MISSING_FILES -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All required files exist"
else
    echo -e "${RED}✗${NC} Some required files missing"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "========================================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ Diagnostic Complete - No Issues Found${NC}"
    echo ""
    echo "Try starting the backend:"
    echo "  node server.js"
    echo "  or"
    echo "  pm2 start server.js --name movieticket-api"
else
    echo -e "${RED}✗ Found $ERRORS issue(s)${NC}"
    echo ""
    echo "Common fixes:"
    echo "  1. Install dependencies: npm install"
    echo "  2. Create .env file: cp env.example .env"
    echo "  3. Start MongoDB: sudo systemctl start mongod"
    echo "  4. Free port: sudo lsof -i :3000"
fi
echo "========================================="

exit $ERRORS

