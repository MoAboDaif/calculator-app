# Simple Calculator Application for Deployment Practices

![Calculator Application UI](app-ui.png)

This full-stack calculator application is designed for practicing deployment strategies, containerization with Docker, and orchestration with Kubernetes. It features a modern React frontend, Flask backend, and MySQL database.

## Table of Contents
1. [Features](#features)
2. [Application Architecture](#application-architecture)
3. [Project Structure](#project-structure)
4. [Prerequisites](#prerequisites)
5. [Quick Start with Docker Compose](#quick-start-with-docker-compose)
6. [Kubernetes Deployment](#kubernetes-deployment)
7. [Configuration](#configuration)
8. [Database Initialization](#database-initialization)
9. [Running Without Docker](#running-without-docker)
10. [Testing](#testing)
11. [Troubleshooting](#troubleshooting)
12. [License](#license)

## Features

- **Modern UI**: Responsive design with dark/light theme
- **Calculation Operations**: Addition, Subtraction, Multiplication, Division
- **History Tracking**: Stores all calculations with timestamps
- **Error Handling**: User-friendly error messages
- **Containerized**: Docker support for all components
- **Kubernetes Ready**: Deployment manifests included
- **CI/CD Friendly**: Designed for pipeline integration

## Application Architecture

The application follows a microservice architecture:

```
User -> Nginx (Proxy) -> Frontend (React)
                          |
                          └──> Backend (Flask) -> MySQL Database
```

### Component Flow:
1. **User** accesses the application via a web browser
2. **Nginx Proxy** routes requests:
   - `/` routes to the frontend service
   - `/api` routes to the backend service
3. **Frontend** (React) serves the user interface and makes API calls to the backend
4. **Backend** (Flask) processes calculation requests and interacts with the database
5. **MySQL Database** stores calculation history

## Project Structure

```
calculator-app/
├── backend/                   # Flask API server
│   ├── Dockerfile
│   ├── app.py                 # Main Flask application
│   ├── calculator.py          # Core calculator functions
│   ├── db.py                  # Database initialization
│   ├── models.py              # Database models
│   ├── requirements.txt       # Python dependencies
│   └── tests/                 # Backend tests
│       ├── test_calculator.py
│       └── test_service.py
│
├── database/                  # Database setup scripts
│   ├── init-db.sh             # Database initialization script
│   ├── init.sql.template      # Database schema template
│   └── seed.sql.template      # Sample data template
│
├── frontend/                  # React application
│   ├── Dockerfile
│   ├── public/                # Static assets
│   │   └── index.html
│   ├── src/                   # Application source
│   │   ├── components/        # React components
│   │   │   ├── Calculator.js
│   │   │   ├── History.js
│   │   │   └── ThemeToggle.js
│   │   ├── services/          # API services
│   │   │   └── api.js
│   │   ├── App.css            # Global styles
│   │   ├── App.js             # Main application
│   │   ├── index.css          # Base styles
│   │   ├── index.js           # Entry point
│   │   └── setupProxy.js      # Development proxy
│   ├── package.json           # Frontend dependencies
│   └── .env                   # Frontend environment variables
│
├── nginx/                     # Reverse proxy configuration
│   ├── templates/
│   │   └── nginx.conf.template  # Nginx config template
│   └── entrypoint.sh          # Nginx startup script
│
├── kubernetes/                # Kubernetes deployment files
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── db-deployment.yaml
│   ├── db-service.yaml
│   ├── nginx-deployment.yaml
│   ├── nginx-service.yaml
│   └── ingress.yaml
│
├── docker-compose.yml         # Docker Compose configuration
└── README.md                  # This documentation
```

## Prerequisites

- **Docker** (v20.10+)
- **Docker Compose** (v2.0+)
- **Kubernetes Cluster** (for Kubernetes deployment, e.g., Minikube, Kind, or cloud-based)
- **kubectl** (for Kubernetes deployment)

## Quick Start with Docker Compose

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/calculator-app.git
   cd calculator-app
   ```

2. **Create environment file**:
   ```bash
   cp .env.example .env
   ```
   Edit the `.env` file with your configuration.

3. **Start the application**:
   ```bash
   docker-compose up --build -d
   ```

4. **Access the application**:
   Open your browser at `http://localhost`

5. **Stop the application**:
   ```bash
   docker-compose down
   ```

## Kubernetes Deployment

### Prerequisites
- Kubernetes cluster running
- `kubectl` configured to connect to your cluster

### Deploy to Kubernetes

1. **Create namespace**:
   ```bash
   kubectl create namespace calculator-app
   ```

2. **Create config maps and secrets**:
   Update the environment variables in `kubernetes/configmap.yaml` and `kubernetes/secret.yaml` then apply:
   ```bash
   kubectl apply -f kubernetes/configmap.yaml -n calculator-app
   kubectl apply -f kubernetes/secret.yaml -n calculator-app
   ```

3. **Deploy MySQL**:
   ```bash
   kubectl apply -f kubernetes/db-deployment.yaml -n calculator-app
   kubectl apply -f kubernetes/db-service.yaml -n calculator-app
   ```

4. **Deploy Backend**:
   ```bash
   kubectl apply -f kubernetes/backend-deployment.yaml -n calculator-app
   kubectl apply -f kubernetes/backend-service.yaml -n calculator-app
   ```

5. **Deploy Frontend**:
   ```bash
   kubectl apply -f kubernetes/frontend-deployment.yaml -n calculator-app
   kubectl apply -f kubernetes/frontend-service.yaml -n calculator-app
   ```

6. **Deploy Nginx and Ingress**:
   ```bash
   kubectl apply -f kubernetes/nginx-deployment.yaml -n calculator-app
   kubectl apply -f kubernetes/nginx-service.yaml -n calculator-app
   kubectl apply -f kubernetes/ingress.yaml -n calculator-app
   ```

7. **Access the application**:
   - If using Minikube: `minikube service nginx-service -n calculator-app`
   - If using cloud provider, get the external IP from the ingress

## Configuration

### Environment Variables
The application is configured using environment variables. See `.env.example` for reference:

```
# Frontend
REACT_APP_API_BASE_URL=/api

# Backend
MYSQL_HOST=db
MYSQL_DB=calculator_db
MYSQL_USER=calculator_user
MYSQL_PASSWORD=securepassword
SECRET_KEY=secretkey

# MySQL
MYSQL_ROOT_PASSWORD=rootpassword

# Nginx
SERVER_NAME=localhost
FRONTEND_HOST=frontend
FRONTEND_PORT=3000
BACKEND_HOST=backend
BACKEND_PORT=5000
```

## Database Initialization

The database is initialized using scripts in the `database` directory. The `init-db.sh` script processes the templates with environment variables:

```bash
#!/bin/sh
envsubst < init.sql.template > init.sql 
envsubst < seed.sql.template > seed.sql
```

The `init.sql.template` creates the database and user:

```sql
CREATE DATABASE IF NOT EXISTS ${MYSQL_DB};
USE ${MYSQL_DB};

CREATE TABLE calculations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    operand1 DOUBLE NOT NULL,
    operand2 DOUBLE NOT NULL,
    operation ENUM('add', 'subtract', 'multiply', 'divide') NOT NULL,
    result DOUBLE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_created_at ON calculations(created_at);

CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
```

## Running Without Docker

### Backend Setup
```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Set environment variables
export MYSQL_HOST=localhost
export MYSQL_USER=calculator_user
export MYSQL_PASSWORD=securepassword
export MYSQL_DB=calculator_db
export SECRET_KEY=secretkey

flask run
```

### Frontend Setup
```bash
cd frontend
npm install

# Set the API base URL (point to backend)
export REACT_APP_API_BASE_URL=http://localhost:5000

npm start
```

### Database Setup
1. Start MySQL server
2. Initialize database:
   ```bash
   mysql -u root -p < database/init.sql
   mysql -u root -p < database/seed.sql
   ```

## Testing

### Backend Tests
```bash
cd backend
python -m unittest discover tests
```

### Frontend Tests
```bash
cd frontend
npm test
```

## Troubleshooting

### Common Issues
- **Database connection issues**: Verify environment variables and database accessibility
- **CORS errors**: Ensure the frontend is making requests to the correct backend URL
- **Nginx configuration errors**: Check the generated Nginx configuration file for correctness

### Logs Inspection
- **Docker Compose**: `docker-compose logs`
- **Kubernetes**: `kubectl logs <pod-name> -n calculator-app`

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
