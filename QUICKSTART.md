# 🚀 Quick Start Guide

This guide will help you get the MovieTicket application running quickly.

## Prerequisites

- Node.js v18+ 
- MongoDB (local or Atlas)
- Docker & Docker Compose (optional but recommended)

## Option 1: Docker Compose (Easiest)

1. **Clone and navigate**
   ```bash
   git clone <repo-url>
   cd project
   ```

2. **Create environment file**
   ```bash
   cd backend
   cp env.example .env
   # Edit .env if needed (defaults work for Docker Compose)
   ```

3. **Start everything**
   ```bash
   cd ..
   docker-compose up -d
   ```

4. **Seed database**
   ```bash
   docker-compose exec api npm run seed
   ```

5. **Access**
   - Frontend: http://localhost:8080
   - API: http://localhost:3000
   - Health: http://localhost:3000/health

6. **Login as admin**
   - Email: `admin@movieticket.com`
   - Password: `admin123`

## Option 2: Local Development

1. **Start MongoDB**
   ```bash
   # Local MongoDB
   mongod
   
   # Or use MongoDB Atlas (update MONGODB_URI in .env)
   ```

2. **Setup Backend**
   ```bash
   cd backend
   cp env.example .env
   npm install
   npm run seed
   npm start
   ```

3. **Serve Frontend**
   ```bash
   cd frontend
   # Using Python
   python -m http.server 8080
   
   # Or using Node.js
   npx http-server -p 8080
   ```

4. **Access**
   - Frontend: http://localhost:8080
   - API: http://localhost:3000

## Option 3: Kubernetes

See [README.md](README.md#kubernetes-deployment) for detailed Kubernetes deployment instructions.

## Next Steps

1. **Create a user account** via Sign Up page
2. **Login** and explore the dashboard
3. **Add movies** via Admin dashboard (admin login)
4. **Book tickets** from user dashboard

## Troubleshooting

### MongoDB connection failed
- Check if MongoDB is running: `mongosh` or `mongo`
- Verify MONGODB_URI in `.env`
- Check firewall settings

### API not responding
- Check backend logs: `docker-compose logs api`
- Verify port 3000 is available
- Check health endpoint: http://localhost:3000/health

### Frontend can't connect to API
- Update API_BASE_URL in `frontend/js/auth.js`
- Check CORS settings in backend
- Verify API is running

For more details, see [README.md](README.md).

