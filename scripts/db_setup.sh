#!/bin/bash
sudo yum update -y
sudo yum install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE testdb;
USE testdb;
CREATE TABLE users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50));
INSERT INTO users (name) VALUES ('InitialUser');
MYSQL_SCRIPT