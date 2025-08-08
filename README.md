
# 📟 Calculator App — Full Stack Application

A full-stack **React + Flask + MySQL** calculator app with a clean architecture, full testing coverage, and production-ready deployment setup via Nginx and Docker.

---

## 📂 Project Structure

```
calculator-app/
│
├── backend/                 # Flask REST API
│   ├── app.py               # Application entry point
│   ├── calculator.py        # Core calculator logic
│   ├── db.py                 # DB connection manager
│   ├── models.py             # Data models and queries
│   ├── requirements.txt      # Python dependencies
│   └── tests/                # Backend tests
│
├── database/                 # MySQL initialization
│   ├── init-db.sh             # Init script
│   ├── init.sql.template      # Schema definition
│   └── seed.sql.template      # Sample data
│
├── frontend/                  # React UI
│   ├── nginx/                 # Nginx production configs
│   ├── public/                # Static HTML
│   └── src/                   # React components & services
│
└── .env                       # Environment variables
```

---

## 🛠 Tech Stack

**Frontend**

* React 18 (CRA)
* Jest + React Testing Library
* Nginx for production serving

**Backend**

* Flask 3.x
* Flask-CORS
* Flask-MySQLdb / mysqlclient
* python-dotenv

**Database**

* MySQL 8
* Schema & seed scripts

---

## 🌍 Architecture Overview

```
[ React Frontend ]
        |
   (API Calls)
        v
[ Flask Backend ]
        |
   (SQL Queries)
        v
[ MySQL Database ]
```

---

## ⚙️ Environment Variables

Example `.env`:

```bash
# Backend
MYSQL_HOST=localhost
MYSQL_USER=dbuser
MYSQL_PASSWORD=dbpassword
MYSQL_DB=calculator_db
SECRET_KEY=your_secure_secret_key
DEBUG=False
ALLOWED_ORIGINS=http://localhost:3000,https://yourproductiondomain.com

# Frontend
REACT_APP_API_BASE_URL=http://localhost:5000
```

---

## 🚀 Local Development

### 1️⃣ Backend

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
flask run --host=0.0.0.0 --port=5000
```

### 2️⃣ Database

```bash
cd database
chmod +x init-db.sh
./init-db.sh
```

### 3️⃣ Frontend

```bash
cd frontend
npm install
npm start
```

---

## 🧪 Running Tests

### Backend Tests

```bash
cd backend
pytest
```

### Frontend Tests

```bash
cd frontend
npm test
```

---

## 📦 Production with Docker

`docker-compose.yml` example:

```yaml
version: '3.8'
services:
  backend:
    build: ./backend
    env_file: .env
    ports:
      - "5000:5000"
    depends_on:
      - db

  frontend:
    build: ./frontend
    ports:
      - "3000:80"
    depends_on:
      - backend

  db:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: calculator_db
      MYSQL_USER: moabodaif
      MYSQL_PASSWORD: password
    volumes:
      - db_data:/var/lib/mysql
      - ./database/init.sql.template:/docker-entrypoint-initdb.d/init.sql
      - ./database/seed.sql.template:/docker-entrypoint-initdb.d/seed.sql

volumes:
  db_data:
```

---

## 📐 API Endpoints

**Base URL:** `${REACT_APP_API_BASE_URL}`

| Method | Endpoint     | Description         |
| ------ | ------------ | ------------------- |
| POST   | `/calculate` | Perform calculation |
| GET    | `/history`   | Get history list    |

Example request:

```json
POST /calculate
{
  "expression": "5+3*2"
}
```

---

## 🎯 Features

* **Dynamic API Base URL** via `.env`
* **Frontend & Backend Tests** with high coverage
* **MySQL Persistence** with seed data
* **Production-ready Nginx setup**
* **Docker Support** for consistent environments
