# 🎬 MovieTicket - Production-Ready Movie Booking System

A complete, production-ready movie ticket booking web application with full DevOps automation, containerization, Kubernetes deployment, CI/CD pipeline, and comprehensive monitoring.

## 📋 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Local Development](#local-development)
- [Docker Deployment](#docker-deployment)
- [EC2 Ubuntu Deployment](#ec2-ubuntu-deployment)
- [Kubernetes Deployment](#kubernetes-deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Monitoring & Observability](#monitoring--observability)
- [Security](#security)
- [Production Hardening](#production-hardening)
- [Backup Strategy](#backup-strategy)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## ✨ Features

### Frontend
- 🏠 Home page with featured movies
- 👤 User authentication (Signup/Login)
- 👨‍💼 Admin authentication
- 📱 Responsive user dashboard
- 🎫 Movie booking with seat selection
- 📜 Booking history and receipts
- 🔧 Admin dashboard for movie management
- 👥 User management (Admin only)
- 📊 Complete booking analytics (Admin)

### Backend
- 🔐 JWT-based authentication with role-based access control
- 🎬 Complete CRUD operations for movies
- 📅 Showtime management
- 💺 Seat booking system
- 📈 Prometheus metrics integration
- 🚦 Rate limiting on authentication routes
- 🛡️ Security middleware (Helmet, CORS)
- 📝 Comprehensive error handling
- 📊 Request logging (Morgan)

### DevOps & Infrastructure
- 🐳 Docker containerization with multi-stage builds
- ☸️ Kubernetes deployment with HPA
- 🔄 Jenkins CI/CD pipeline
- 📊 Prometheus & Grafana monitoring
- 🤖 Ansible automation for infrastructure
- 🔍 Health checks and readiness probes
- 📦 Automated image building and deployment

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        User Browser                          │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    Nginx (Frontend)                          │
│              (Static HTML/CSS/JS)                            │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ /api/*
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                   Node.js/Express API                        │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │   Auth      │  │   Movies     │  │    Bookings      │   │
│  │   Routes    │  │   Routes     │  │    Routes        │   │
│  └─────────────┘  └──────────────┘  └──────────────────┘   │
│                                                               │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │   JWT Auth  │  │  Prometheus  │  │  Error Handler   │   │
│  │  Middleware │  │   Metrics    │  │   Middleware     │   │
│  └─────────────┘  └──────────────┘  └──────────────────┘   │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                      MongoDB                                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                  │
│  │  Users   │  │  Movies  │  │ Bookings │                  │
│  └──────────┘  └──────────┘  └──────────┘                  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   Monitoring Stack                           │
│  ┌──────────────┐         ┌──────────────┐                 │
│  │  Prometheus  │ ◄──────► │   Grafana    │                 │
│  │  (Metrics)   │         │  (Dashboards) │                 │
│  └──────────────┘         └──────────────┘                 │
└─────────────────────────────────────────────────────────────┘
```

## 🛠️ Tech Stack

### Frontend
- **HTML5** - Semantic markup
- **CSS3** - Modern styling with custom properties
- **Vanilla JavaScript** - ES6+ with Fetch API
- **Nginx** - Web server and reverse proxy

### Backend
- **Node.js** (v18+) - Runtime environment
- **Express.js** - Web framework
- **MongoDB** - NoSQL database
- **Mongoose** - ODM for MongoDB
- **JWT** - Authentication tokens
- **bcryptjs** - Password hashing
- **Prometheus Client** - Metrics collection

### DevOps & Infrastructure
- **Docker** - Containerization
- **Docker Compose** - Local orchestration
- **Kubernetes** - Container orchestration
- **Jenkins** - CI/CD automation
- **Prometheus** - Metrics collection
- **Grafana** - Visualization and dashboards
- **Ansible** - Infrastructure automation
- **Nginx Ingress** - Kubernetes ingress controller

## 📁 Project Structure

```
movieticket/
├── frontend/                 # Frontend application
│   ├── css/
│   │   └── style.css        # Main stylesheet
│   ├── js/
│   │   ├── auth.js          # Authentication utilities
│   │   ├── index.js         # Home page logic
│   │   ├── login.js         # Login functionality
│   │   ├── signup.js        # Signup functionality
│   │   ├── dashboard.js     # User dashboard
│   │   ├── admin.js         # Admin dashboard
│   │   ├── booking.js       # Booking flow
│   │   └── receipt.js       # Receipt display
│   ├── index.html           # Home page
│   ├── login.html           # Login page
│   ├── signup.html          # Signup page
│   ├── dashboard.html       # User dashboard
│   ├── admin.html           # Admin dashboard
│   ├── booking.html         # Booking page
│   └── receipt.html         # Receipt page
│
├── backend/                  # Backend API
│   ├── config/
│   │   └── database.js      # MongoDB connection
│   ├── middleware/
│   │   ├── auth.js          # JWT authentication
│   │   ├── errorHandler.js  # Error handling
│   │   └── metrics.js       # Prometheus metrics
│   ├── models/
│   │   ├── User.js          # User model
│   │   ├── Movie.js         # Movie model
│   │   └── Booking.js       # Booking model
│   ├── routes/
│   │   ├── auth.js          # Authentication routes
│   │   ├── movies.js        # Movie routes
│   │   ├── bookings.js      # Booking routes
│   │   └── users.js         # User routes
│   ├── scripts/
│   │   └── seed.js          # Database seed script
│   ├── server.js            # Express server
│   ├── package.json         # Dependencies
│   └── Dockerfile           # Docker image definition
│
├── k8s/                      # Kubernetes manifests
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── hpa.yaml             # Horizontal Pod Autoscaler
│   ├── mongo-statefulset.yaml
│   ├── ingress.yaml
│   └── prometheus-rules.yaml
│
├── ansible/                  # Ansible playbooks
│   ├── inventory
│   ├── site.yaml
│   └── roles/
│       ├── common/
│       ├── docker/
│       ├── k8s/
│       ├── jenkins/
│       └── k8s-deploy/
│
├── docker-compose.yml        # Docker Compose configuration
├── nginx.conf                # Nginx configuration
├── Jenkinsfile               # Jenkins CI/CD pipeline
└── README.md                 # This file
```

## 🚀 Quick Start

### Prerequisites

- **Node.js** (v18 or higher)
- **MongoDB** (v7.0 or higher) or MongoDB Atlas account
- **Docker** & **Docker Compose** (for containerized deployment)
- **kubectl** (for Kubernetes deployment)
- **Jenkins** (for CI/CD)

### Deployment Options

1. **Local Development** - Run on your local machine
2. **Docker Compose** - Containerized local deployment
3. **EC2 Ubuntu** - Deploy on AWS EC2 instance ([Complete Guide](docs/EC2_UBUNTU_SETUP.md))
4. **Kubernetes** - Deploy on Kubernetes cluster
5. **Production** - See production hardening section

### Option 1: Local Development (Without Docker)

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd project
   ```

2. **Set up MongoDB**
   - Install MongoDB locally or use MongoDB Atlas
   - Start MongoDB service: `mongod`

3. **Configure Backend**
   ```bash
   cd backend
   cp .env.example .env
   # Edit .env with your MongoDB URI and JWT secret
   npm install
   npm run seed  # Creates admin user
   npm start
   ```

4. **Serve Frontend**
   ```bash
   # Using Python (if installed)
   cd frontend
   python -m http.server 8080
   
   # Or using Node.js http-server
   npx http-server -p 8080
   ```

5. **Access the application**
   - Frontend: http://localhost:8080
   - API: http://localhost:3000
   - Health check: http://localhost:3000/health
   - Metrics: http://localhost:3000/metrics

### Option 2: Docker Compose (Recommended for Local)

1. **Create environment file**
   ```bash
   cd backend
   cp .env.example .env
   # Edit .env if needed
   ```

2. **Start all services**
   ```bash
   docker-compose up -d
   ```

3. **Seed database**
   ```bash
   docker-compose exec api npm run seed
   ```

4. **Access the application**
   - Frontend: http://localhost:8080
   - API: http://localhost:3000

### Default Admin Credentials

After running the seed script:
- **Email**: `admin@movieticket.com`
- **Password**: `admin123`

⚠️ **Change these credentials in production!**

## 💻 Local Development

### Backend Development

```bash
cd backend

# Install dependencies
npm install

# Run in development mode (with nodemon)
npm run dev

# Run seed script
npm run seed

# Run tests
npm test
```

### Frontend Development

The frontend uses vanilla JavaScript, so no build process is required. Simply serve the files:

```bash
cd frontend

# Using Python
python -m http.server 8080

# Using Node.js
npx http-server -p 8080

# Using PHP
php -S localhost:8080
```

### Environment Variables

Create a `.env` file in the `backend/` directory:

```env
PORT=3000
NODE_ENV=development
MONGODB_URI=mongodb://localhost:27017/movieticket
JWT_SECRET=your-super-secret-jwt-key-change-this
JWT_EXPIRE=7d
CORS_ORIGIN=http://localhost:8080
```

## 🐳 Docker Deployment

### Build Images

```bash
# Build backend image
docker build -t movieticket-api:latest ./backend

# Build frontend image (uses nginx:alpine)
# Frontend is served via nginx, no separate build needed
```

### Docker Compose

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Docker Compose Services

- **api**: Node.js backend (port 3000)
- **mongo**: MongoDB database (port 27017)
- **frontend**: Nginx web server (port 8080)

## 🖥️ EC2 Ubuntu Deployment

Deploy the MovieTicket application on an AWS EC2 Ubuntu instance from scratch.

### Quick Setup

For a complete step-by-step guide, see **[EC2 Ubuntu Setup Guide](docs/EC2_UBUNTU_SETUP.md)**.

### Quick Start (Automated)

```bash
# 1. Connect to your EC2 instance
ssh -i your-key.pem ubuntu@your-ec2-ip

# 2. Run automated setup script
cd ~
wget -O ec2-setup.sh https://raw.githubusercontent.com/your-repo/scripts/ec2-setup.sh
chmod +x ec2-setup.sh
./ec2-setup.sh

# 3. Upload application files (from local machine)
scp -i your-key.pem -r ./movieticket ubuntu@your-ec2-ip:~/

# 4. Setup and start application
cd ~/movieticket/backend
cp env.example .env
nano .env  # Configure your settings
npm install --production
npm run seed
pm2 start server.js --name movieticket-api
pm2 save
pm2 startup  # Follow the instructions

# 5. Setup Nginx reverse proxy (optional)
sudo ./scripts/setup-nginx.sh your-domain.com /home/ubuntu/movieticket
sudo certbot --nginx -d your-domain.com
```

### Manual Setup Steps

1. **Install Prerequisites**
   - Node.js v18+
   - MongoDB (local or Atlas)
   - Nginx
   - PM2 (process manager)

2. **Configure Application**
   - Upload files to EC2
   - Setup environment variables
   - Seed database

3. **Start Application**
   - Use PM2 or systemd
   - Configure Nginx as reverse proxy
   - Setup SSL certificates

4. **Security Hardening**
   - Configure firewall (UFW)
   - Setup Fail2Ban
   - Enable SSL/TLS

### Available Scripts

- `scripts/ec2-setup.sh` - Automated prerequisites installation
- `scripts/setup-nginx.sh` - Nginx configuration
- `scripts/setup-systemd.sh` - Systemd service setup

### Documentation

- **[Complete EC2 Setup Guide](docs/EC2_UBUNTU_SETUP.md)** - Detailed step-by-step instructions
- **[EC2 Quick Reference](docs/EC2_QUICK_REFERENCE.md)** - Command cheat sheet

### Key Features

- ✅ Automated installation scripts
- ✅ Nginx reverse proxy configuration
- ✅ SSL/TLS setup with Let's Encrypt
- ✅ PM2 process management
- ✅ Systemd service configuration
- ✅ Security hardening (UFW, Fail2Ban)
- ✅ Production-ready deployment

## ☸️ Kubernetes Deployment

### Prerequisites

- Kubernetes cluster (v1.28+)
- kubectl configured
- Access to container registry (Docker Hub, ECR, GCR, etc.)

### Step 1: Create Secrets

```bash
# Create namespace
kubectl create namespace movieticket

# Create JWT secret
kubectl create secret generic movieticket-secret \
  --from-literal=JWT_SECRET='your-super-secret-jwt-key' \
  --namespace=movieticket

# Or edit the secret.yaml file and apply
kubectl apply -f k8s/secret.yaml
```

### Step 2: Build and Push Docker Image

```bash
# Build image
docker build -t your-registry/movieticket-api:latest ./backend

# Push to registry
docker push your-registry/movieticket-api:latest

# Update deployment.yaml with your image name
```

### Step 3: Apply Kubernetes Manifests

```bash
# Apply all manifests
kubectl apply -f k8s/

# Or apply individually
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/mongo-statefulset.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml
```

### Step 4: Verify Deployment

```bash
# Check pods
kubectl get pods -n movieticket

# Check services
kubectl get svc -n movieticket

# Check deployments
kubectl get deployments -n movieticket

# View logs
kubectl logs -f deployment/movieticket-api -n movieticket
```

### Step 5: Access the Application

```bash
# Port forward to access locally
kubectl port-forward svc/movieticket-frontend 8080:80 -n movieticket

# Access via Ingress (if configured)
# Update ingress.yaml with your domain and apply
```

### Horizontal Pod Autoscaler (HPA)

HPA automatically scales pods based on CPU and memory usage:
- **Min replicas**: 3 (API), 2 (Frontend)
- **Max replicas**: 10 (API), 5 (Frontend)
- **Target CPU**: 70%
- **Target Memory**: 80%

### MongoDB in Kubernetes

The project includes a MongoDB StatefulSet. For production, consider:
- MongoDB Atlas (managed service)
- MongoDB Operator
- Persistent volumes for data

## 🔄 CI/CD Pipeline

### Jenkins Pipeline Overview

The Jenkinsfile defines a complete CI/CD pipeline:

1. **Checkout**: Get source code
2. **Install Dependencies**: `npm ci`
3. **Lint & Test**: Run linting and tests
4. **Build Docker Image**: Multi-stage build
5. **Tag Image**: Tag with build number and latest
6. **Push to Registry**: Push to container registry
7. **Deploy to Kubernetes**: Update deployment
8. **Smoke Test**: Verify deployment health

### Jenkins Setup

1. **Create Jenkins Credentials**

   - `docker-registry-url`: Your container registry URL
   - `docker-registry-creds`: Docker registry credentials
   - `kubeconfig-secret`: Kubernetes kubeconfig file

2. **Create Jenkins Pipeline**

   - Create new Pipeline job
   - Point to Jenkinsfile in repository
   - Configure webhook for automatic builds

3. **Pipeline Configuration**

   ```groovy
   // Jenkinsfile is already configured
   // Just point Jenkins to the repository
   ```

### Manual Deployment

```bash
# Build and tag
docker build -t movieticket-api:$BUILD_NUMBER ./backend
docker tag movieticket-api:$BUILD_NUMBER movieticket-api:latest

# Push to registry
docker push movieticket-api:$BUILD_NUMBER
docker push movieticket-api:latest

# Deploy to Kubernetes
kubectl set image deployment/movieticket-api \
  api=movieticket-api:$BUILD_NUMBER \
  -n movieticket

# Verify rollout
kubectl rollout status deployment/movieticket-api -n movieticket
```

## 📊 Monitoring & Observability

### Prometheus Metrics

The application exposes Prometheus metrics at `/metrics`:

- **http_request_duration_seconds**: Request latency histogram
- **http_requests_total**: Total HTTP requests counter
- **http_errors_total**: HTTP errors counter
- **Default Node.js metrics**: CPU, memory, event loop, etc.

### Prometheus Setup

1. **Install Prometheus Operator** (using Helm)

   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   helm install prometheus prometheus-community/kube-prometheus-stack \
     --namespace monitoring \
     --create-namespace
   ```

2. **Configure ServiceMonitor**

   Create a ServiceMonitor to scrape metrics:

   ```yaml
   apiVersion: monitoring.coreos.com/v1
   kind: ServiceMonitor
   metadata:
     name: movieticket-api
     namespace: movieticket
   spec:
     selector:
       matchLabels:
         app: movieticket-api
     endpoints:
     - port: http
       path: /metrics
       interval: 30s
   ```

3. **Access Prometheus**

   ```bash
   kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring
   # Access at http://localhost:9090
   ```

### Grafana Dashboards

1. **Access Grafana**

   ```bash
   kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
   # Default credentials: admin/prom-operator
   ```

2. **Import Dashboard**

   Create a dashboard with panels for:
   - Requests per second
   - Error rate
   - Latency (p50, p95, p99)
   - MongoDB metrics
   - Container CPU/Memory usage

3. **Sample Dashboard JSON**

   ```json
   {
     "dashboard": {
       "title": "MovieTicket API Dashboard",
       "panels": [
         {
           "title": "Request Rate",
           "targets": [{
             "expr": "rate(http_requests_total[5m])"
           }]
         },
         {
           "title": "Error Rate",
           "targets": [{
             "expr": "rate(http_errors_total[5m])"
           }]
         },
         {
           "title": "Latency (p95)",
           "targets": [{
             "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))"
           }]
         }
       ]
     }
   }
   ```

### Alerting Rules

Prometheus alerting rules are defined in `k8s/prometheus-rules.yaml`:

- High error rate (>10%)
- High latency (>2s p95)
- Pod crash looping
- High memory/CPU usage
- MongoDB down
- API unavailable

## 🔒 Security

### Implemented Security Features

- ✅ **Helmet.js**: Security headers
- ✅ **CORS**: Configured origin restrictions
- ✅ **JWT Authentication**: Secure token-based auth
- ✅ **Password Hashing**: bcrypt with salt
- ✅ **Rate Limiting**: On authentication routes
- ✅ **Input Validation**: Request validation
- ✅ **Non-root User**: Docker containers run as non-root
- ✅ **Secrets Management**: Kubernetes secrets
- ✅ **HTTPS**: Via Ingress with TLS

### Security Best Practices

1. **Change Default Credentials**
   ```bash
   # After first deployment, change admin password
   ```

2. **Use Strong JWT Secret**
   ```bash
   # Generate strong secret
   openssl rand -base64 32
   ```

3. **Enable HTTPS**
   - Configure TLS certificates in Ingress
   - Use Let's Encrypt with cert-manager

4. **Network Policies**
   ```yaml
   # Restrict pod-to-pod communication
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: movieticket-netpol
     namespace: movieticket
   spec:
     podSelector: {}
     policyTypes:
     - Ingress
     - Egress
     ingress:
     - from:
       - namespaceSelector:
           matchLabels:
             name: ingress-nginx
     egress:
     - to:
       - podSelector:
           matchLabels:
             app: movieticket-mongo
     - to:
       - namespaceSelector: {}
       ports:
       - protocol: TCP
         port: 53  # DNS
   ```

5. **Regular Security Updates**
   ```bash
   # Update dependencies
   npm audit fix
   docker scan movieticket-api:latest
   ```

## 🏭 Production Hardening

### Environment Configuration

1. **Set Production Environment**
   ```env
   NODE_ENV=production
   ```

2. **Use MongoDB Atlas** (Recommended)
   - Managed MongoDB service
   - Automatic backups
   - High availability
   - Update `MONGODB_URI` in ConfigMap

3. **Resource Limits**
   - Already configured in `deployment.yaml`
   - Adjust based on load testing

4. **Enable Logging**
   - Use centralized logging (ELK, Loki)
   - Configure log aggregation

5. **Backup Strategy**
   - MongoDB backups (see Backup Strategy section)
   - Configuration backups
   - Image registry backups

### Performance Optimization

1. **Database Indexing**
   - Already configured in models
   - Monitor slow queries

2. **Caching**
   - Add Redis for session management
   - Cache movie data
   - Cache user data

3. **CDN**
   - Serve static assets via CDN
   - Use CloudFlare or AWS CloudFront

4. **Load Balancing**
   - Use Kubernetes service load balancing
   - Configure ingress load balancing

## 💾 Backup Strategy

### MongoDB Backups

#### Option 1: MongoDB Atlas (Recommended)

- Automatic daily backups
- Point-in-time recovery
- Easy restore process

#### Option 2: Manual Backups

```bash
# Backup database
mongodump --uri="mongodb://localhost:27017/movieticket" \
  --out=/backup/mongodb-$(date +%Y%m%d)

# Restore database
mongorestore --uri="mongodb://localhost:27017/movieticket" \
  /backup/mongodb-20240101/movieticket
```

#### Option 3: Kubernetes CronJob

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: mongodb-backup
  namespace: movieticket
spec:
  schedule: "0 2 * * *"  # Daily at 2 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: mongo:7.0
            command:
            - mongodump
            - --uri=mongodb://movieticket-mongo:27017/movieticket
            - --out=/backup
            volumeMounts:
            - name: backup-storage
              mountPath: /backup
          volumes:
          - name: backup-storage
            persistentVolumeClaim:
              claimName: mongo-backup-pvc
          restartPolicy: OnFailure
```

### Backup Storage

1. **Cloud Storage**
   - AWS S3
   - Google Cloud Storage
   - Azure Blob Storage

2. **Retention Policy**
   - Daily backups: 7 days
   - Weekly backups: 4 weeks
   - Monthly backups: 12 months

3. **Backup Testing**
   - Test restore monthly
   - Verify backup integrity
   - Document restore procedures

## 🔧 Troubleshooting

### Common Issues

#### 1. MongoDB Connection Failed

```bash
# Check MongoDB status
docker-compose ps mongo
kubectl get pods -n movieticket | grep mongo

# Check logs
docker-compose logs mongo
kubectl logs -n movieticket movieticket-mongo-0

# Verify connection string
echo $MONGODB_URI
```

#### 2. API Not Responding

```bash
# Check API logs
docker-compose logs api
kubectl logs -n movieticket deployment/movieticket-api

# Check health endpoint
curl http://localhost:3000/health

# Check service
kubectl get svc -n movieticket
```

#### 3. Frontend Not Loading

```bash
# Check Nginx logs
docker-compose logs frontend
kubectl logs -n movieticket deployment/movieticket-frontend

# Verify static files
ls -la frontend/

# Check Nginx configuration
nginx -t -c nginx.conf
```

#### 4. Authentication Issues

```bash
# Verify JWT secret is set
echo $JWT_SECRET

# Check token expiration
# Default is 7 days, can be adjusted in .env

# Verify user exists
# Run seed script or check database
```

#### 5. Kubernetes Deployment Issues

```bash
# Describe deployment
kubectl describe deployment movieticket-api -n movieticket

# Check events
kubectl get events -n movieticket --sort-by='.lastTimestamp'

# Check resource usage
kubectl top pods -n movieticket

# Check HPA status
kubectl get hpa -n movieticket
```

### Debug Commands

```bash
# Get all resources
kubectl get all -n movieticket

# Describe resource
kubectl describe pod <pod-name> -n movieticket

# Exec into container
kubectl exec -it <pod-name> -n movieticket -- /bin/sh

# View logs with tail
kubectl logs -f <pod-name> -n movieticket

# Port forward for debugging
kubectl port-forward svc/movieticket-api 3000:80 -n movieticket
```

## 📚 Additional Resources

- [Express.js Documentation](https://expressjs.com/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Prometheus Documentation](https://prometheus.io/docs/)

## 📝 License

This project is licensed under the ISC License.

## 👥 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 🙏 Acknowledgments

- Express.js team for the excellent framework
- MongoDB for the powerful database
- Kubernetes community for container orchestration
- All open-source contributors

---

**Built with ❤️ for production-ready movie ticket booking**

For questions or issues, please open an issue on GitHub.

