# 🚀 Quick Fix: Backend Won't Start

## ⚡ Fastest Solution (5 minutes)

Run these commands in order:

```bash
# 1. Go to backend directory
cd ~/movieticket/backend

# 2. Run auto-fix script
chmod +x ../scripts/fix-backend.sh
../scripts/fix-backend.sh

# 3. Edit .env file (if needed)
nano .env
# Make sure these are set:
# - MONGODB_URI=mongodb://localhost:27017/movieticket
# - JWT_SECRET=any-secret-key

# 4. Ensure MongoDB is running
sudo systemctl start mongod

# 5. Try starting backend
node server.js
```

## 🔍 Most Common Issues

### Issue 1: Missing .env file

```bash
cd ~/movieticket/backend
cp env.example .env
nano .env  # Edit with your config
```

### Issue 2: Dependencies not installed

```bash
cd ~/movieticket/backend
npm install
```

### Issue 3: MongoDB not running

```bash
sudo systemctl start mongod
sudo systemctl enable mongod
```

### Issue 4: Port 3000 in use

```bash
sudo lsof -i :3000
sudo kill -9 PID  # Replace PID with actual process ID
```

## 📋 Step-by-Step Fix

1. **Check Node.js**
   ```bash
   node --version  # Should be v18 or higher
   ```

2. **Install Dependencies**
   ```bash
   cd ~/movieticket/backend
   npm install
   ```

3. **Create .env File**
   ```bash
   cd ~/movieticket/backend
   cp env.example .env
   nano .env
   ```
   
   Minimum required:
   ```env
   PORT=3000
   MONGODB_URI=mongodb://localhost:27017/movieticket
   JWT_SECRET=your-secret-key-here
   ```

4. **Start MongoDB**
   ```bash
   sudo systemctl start mongod
   ```

5. **Test Start**
   ```bash
   cd ~/movieticket/backend
   node server.js
   ```

   You should see:
   ```
   MongoDB connected successfully
   Server running on port 3000 in production mode
   ```

6. **Start with PM2**
   ```bash
   pm2 start server.js --name movieticket-api
   pm2 save
   ```

## 🛠️ Diagnostic Script

Run this to identify the problem:

```bash
cd ~/movieticket/backend
chmod +x ../scripts/check-backend.sh
../scripts/check-backend.sh
```

## 📖 Detailed Guide

For comprehensive troubleshooting, see:
- **[Backend Troubleshooting Guide](docs/BACKEND_TROUBLESHOOTING.md)** - Complete guide with all solutions
- **[EC2 Setup Guide](docs/EC2_UBUNTU_SETUP.md)** - Full deployment guide

## ✅ Success Checklist

- [ ] Node.js installed (v18+)
- [ ] Dependencies installed (`npm install`)
- [ ] .env file created and configured
- [ ] MongoDB running (`sudo systemctl status mongod`)
- [ ] Port 3000 available
- [ ] All files uploaded correctly

## 🆘 Still Not Working?

1. Check logs:
   ```bash
   cd ~/movieticket/backend
   node server.js
   # Look for error messages
   ```

2. Run diagnostic:
   ```bash
   ../scripts/check-backend.sh
   ```

3. Check MongoDB connection:
   ```bash
   mongosh --eval "db.adminCommand('ping')"
   ```

4. See detailed troubleshooting: [docs/BACKEND_TROUBLESHOOTING.md](docs/BACKEND_TROUBLESHOOTING.md)

---

**99% of issues are:**
1. Missing `.env` file
2. MongoDB not running
3. Dependencies not installed

Fix these first! 🎯

