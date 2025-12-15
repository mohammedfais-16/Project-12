.PHONY: help install dev build docker-build docker-up docker-down seed test clean

help:
	@echo "MovieTicket Application - Makefile Commands"
	@echo ""
	@echo "  make install      - Install backend dependencies"
	@echo "  make dev          - Start backend in development mode"
	@echo "  make seed         - Seed database with admin user"
	@echo "  make build        - Build Docker images"
	@echo "  make docker-up    - Start all services with Docker Compose"
	@echo "  make docker-down  - Stop all services"
	@echo "  make test         - Run tests"
	@echo "  make clean        - Clean node_modules and build artifacts"

install:
	cd backend && npm install

dev:
	cd backend && npm run dev

seed:
	cd backend && npm run seed

build:
	docker build -t movieticket-api:latest ./backend
	docker build -t movieticket-frontend:latest ./frontend

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-logs:
	docker-compose logs -f

test:
	cd backend && npm test

clean:
	rm -rf backend/node_modules
	rm -rf backend/.env
	find . -type d -name node_modules -exec rm -rf {} +
	find . -type f -name "*.log" -delete

k8s-deploy:
	./scripts/deploy-k8s.sh

k8s-status:
	kubectl get all -n movieticket

k8s-logs:
	kubectl logs -f deployment/movieticket-api -n movieticket

