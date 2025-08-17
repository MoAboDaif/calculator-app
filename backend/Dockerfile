FROM python:3.13.7-slim

WORKDIR /app

RUN apk-get update && \
    apk-get install -y --no-install-recommends \
    gcc \
    musl-dev \
    libffi-dev \
    mariadb-dev \
    pkgconfig && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

ENTRYPOINT [ "gunicorn", "--bind", "0.0.0.0:5000", "app:app" ]
