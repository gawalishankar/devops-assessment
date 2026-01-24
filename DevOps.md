# DevOps Assessment: Full-Stack Hello World Application

## Overview

This project is a **Full-Stack Hello World application**:

- **Backend:** Django 6 REST API  
- **Frontend:** React (Vite + TypeScript)  
- **Deployment:** Docker containers, EC2 (AWS), and Docker Hub for images  

The goal is to containerize, automate, and deploy the application using **industry-standard DevOps practices**.

---

## 1. Setup Guide

This guide shows **how to run the project locally** and **on an AWS EC2 server**.

---

### 1.1 Local Setup (Development)

#### Prerequisites:

- Docker & Docker Compose installed  
- Node.js & npm (optional, for building frontend locally)  
- Git  

#### Steps:

1. Clone the repository:

```bash
git clone https://github.com/Nexgensis/devops-assessment.git
cd devops-assessment
Build and run backend container:

cd backend
docker build -t shiv201/django-backend .
docker run -d -p 8000:8000 shiv201/django-backend
Build and run frontend container:

cd ../frontend
docker build -t shiv201/react-frontend .
docker run -d -p 3000:80 -e VITE_API_URL=http://localhost:8000/api shiv201/react-frontend
Test locally:

Frontend: http://localhost:3000

Backend API: http://localhost:8000/api/hello/




Troubleshooting Log (Local)

Problem:

When running the React frontend locally, the app showed “Connection Failed” and the backend API requests were failing.

Failed to connect to the backend. Please ensure the Django server is running.


Cause:

The frontend React app was trying to reach the backend at:

axios.get('http://localhost:8000/api/hello/')


This works only if the backend container is running and accessible from the host machine.

Locally, the backend container was not mapped to the correct port or the container had not started yet.

Solution:

Start the backend container with proper port mapping:

cd backend
docker build -t shiv201/django-backend .
docker run -d -p 8000:8000 shiv201/django-backend


Ensure backend is running:

curl http://localhost:8000/api/hello/
# {"message": "Hello World from Django Backend!"}


Start the frontend container pointing to backend:

cd frontend
docker build -t shiv201/react-frontend .
docker run -d -p 3000:80 -e VITE_API_URL=http://localhost:8000/api shiv201/react-frontend


Open browser:

http://localhost:3000