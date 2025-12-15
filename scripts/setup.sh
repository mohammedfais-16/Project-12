#!/bin/bash

# MovieTicket Application Setup Script
# This script helps set up the development environment

set -e

echo "🎬 MovieTicket Application Setup"
echo "================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check prerequisites
check_prerequisites() {
    echo "Checking prerequisites..."
    
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js is not installed. Please install Node.js v18 or higher.${NC}"
        exit 1
    fi
    
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        echo -e "${RED}❌ Node.js version must be 18 or higher. Current version: $(node -v)${NC}"
        exit 1
    fi
    
    if ! command -v docker &> /dev/null; then
        echo -e "${YELLOW}⚠️  Docker is not installed. Docker Compose setup will not work.${NC}"
    fi
    
    echo -e "${GREEN}✅ Prerequisites check passed${NC}"
    echo ""
}

# Setup backend
setup_backend() {
    echo "Setting up backend..."
    cd backend
    
    if [ ! -f .env ]; then
        echo "Creating .env file from template..."
        cp env.example .env
        echo -e "${YELLOW}⚠️  Please edit backend/.env with your configuration${NC}"
    fi
    
    if [ ! -d node_modules ]; then
        echo "Installing backend dependencies..."
        npm install
    fi
    
    echo -e "${GREEN}✅ Backend setup complete${NC}"
    cd ..
    echo ""
}

# Setup database
setup_database() {
    echo "Setting up database..."
    
    read -p "Do you want to seed the database with admin user? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd backend
        npm run seed
        echo -e "${GREEN}✅ Database seeded${NC}"
        cd ..
    fi
    
    echo ""
}

# Build Docker images
build_docker_images() {
    if ! command -v docker &> /dev/null; then
        echo -e "${YELLOW}⚠️  Docker not available, skipping Docker image build${NC}"
        return
    fi
    
    echo "Building Docker images..."
    
    echo "Building backend image..."
    docker build -t movieticket-api:latest ./backend
    
    echo "Building frontend image..."
    docker build -t movieticket-frontend:latest ./frontend
    
    echo -e "${GREEN}✅ Docker images built${NC}"
    echo ""
}

# Main execution
main() {
    check_prerequisites
    setup_backend
    setup_database
    
    read -p "Do you want to build Docker images? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        build_docker_images
    fi
    
    echo ""
    echo -e "${GREEN}🎉 Setup complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Edit backend/.env with your configuration"
    echo "2. Start MongoDB (or use MongoDB Atlas)"
    echo "3. Run 'cd backend && npm start' to start the API"
    echo "4. Serve frontend files (see README.md)"
    echo "5. Or use 'docker-compose up' to start everything"
    echo ""
}

main

