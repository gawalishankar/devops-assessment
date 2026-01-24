# DevOps Fresher Assessment – Full-Stack Deployment

This project demonstrates **containerization, CI/CD, and cloud deployment** for a full-stack application using Django (Backend) and React (Frontend). It applies industry-standard DevOps practices with Docker, Docker Compose, GitHub Actions, and Terraform + AWS EC2.

---

## Project Overview

* **Backend:** Django 6.0 REST API
* **Frontend:** React (Vite + TypeScript)
* **Objective:** Containerize both apps, automate builds and deployment with CI/CD, deploy to cloud.

---

## Project Structure

* `backend/` – Django backend
* `frontend/` – React frontend
* `docker-compose.yml` – Orchestrates frontend and backend
* `.github/workflows/` – CI/CD pipeline
* `terraform/` – cloud infrastructure
* `DEVOPS.md` – Documentation and troubleshooting

---

## Prerequisites

* Docker & Docker Compose installed
* Node.js & npm installed (for frontend development)
* Python 3.11+ (for backend development)
* Git & GitHub account
* AWS account & Terraform (cloud deployment)

---

## Steps to Complete the Project with Commands

### 1. Clone the Repository

```bash
git clone https://github.com/Nexgensis/devops-assessment.git
cd devops-assessment
```

### 2. Containerize Backend

* Create Dockerfile for Django backend.
* Ensure multi-stage build and non-root user.
* **Commands to build and run backend container:**

```bash
cd backend
docker build -t django-backend .
docker run -p 8000:8000 django-backend
```

* Test backend in browser: [http://localhost:8000](http://localhost:8000)

### 3. Containerize Frontend

* Create Dockerfile for React frontend.
* Use multi-stage build and Nginx to serve production.
* **Commands to build and run frontend container:**

```bash
cd ../frontend
docker build -t react-frontend .
docker run -p 3000:80 react-frontend
```

* Test frontend in browser: [http://localhost:3000](http://localhost:3000)

### 4. Docker Compose Setup

* Create `docker-compose.yml` to run both services together.
* **Commands to run full stack:**

```bash
cd ..
docker-compose up --build
```

* Access:

  * Frontend: [http://localhost:3000](http://localhost:3000)
  * Backend: [http://localhost:8000](http://localhost:8000)
* Stop containers:

```bash
docker-compose down
```

### 5. CI/CD Pipeline with GitHub Actions

* Configure workflow in `.github/workflows/docker-ci.yml`.
* Add Docker Hub credentials in GitHub Secrets: `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`.
* **Push code to trigger CI/CD:**

```bash
git add .
git commit -m "Add Dockerfiles, Compose, CI/CD workflow"
git push origin main
```

* Verify workflow on GitHub Actions tab.

### 6. Cloud Deployment

* Create Terraform configuration in `terraform/`.
* **Commands to deploy EC2 instance:**

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

* SSH into EC2:

```bash
ssh -i ~/.ssh/devops-key.pem ec2-user@<EC2_PUBLIC_IP>
```

* Install Docker on EC2:

```bash
sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
```

* Pull and run Docker images:

```bash
docker pull yourname/django-backend
docker pull yourname/react-frontend
docker run -d -p 8000:8000 yourname/django-backend
docker run -d -p 80:80 yourname/react-frontend
```

* Access deployed app: http://<EC2_PUBLIC_IP>

### 8. Clean Up 

* To remove EC2 and avoid AWS charges:

```bash
terraform destroy
```

---

## Key Learnings

* Docker multi-stage builds & security best practices
* Docker Compose orchestration
* CI/CD automation with GitHub Actions
* Cloud infrastructure provisioning with Terraform
* Environment configuration and troubleshooting

---

## Local Access

* **Frontend:** [http://localhost:3000](http://localhost:3000)
* **Backend:** [http://localhost:8000](http://localhost:8000)

## Cloud Access

* **Application URL:** http://<EC2_PUBLIC_IP>
* **API URL:** http://<EC2_PUBLIC_IP>:8000
