CREATE DATABASE IF NOT EXISTS calculator_db;
USE calculator_db;

CREATE TABLE calculations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    operand1 DOUBLE NOT NULL,
    operand2 DOUBLE NOT NULL,
    operation ENUM('add', 'subtract', 'multiply', 'divide') NOT NULL,
    result DOUBLE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_created_at ON calculations(created_at);

CREATE USER 'calculator_user'@'localhost' IDENTIFIED BY 'securepassword';

GRANT ALL PRIVILEGES ON calculator_db.* TO 'calculator_user'@'localhost';

FLUSH PRIVILEGES;
