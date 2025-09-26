#!/bin/bash
echo "🚀 Starting database initialization..."

# Wait for MySQL to be ready
echo "⏳ Waiting for MySQL to be ready..."
until mysqladmin ping -h"mysql" -u"user" -p"password" --silent; do
    echo "MySQL is unavailable - sleeping"
    sleep 2
done

echo "✅ MySQL is ready!"

# Create the database if it doesn't exist
echo "📊 Creating database if not exists..."
mysql -h"mysql" -u"user" -p"password" -e "CREATE DATABASE IF NOT EXISTS liquibase_db;"

# Create the login table
echo "🔧 Creating login table..."
mysql -h"mysql" -u"user" -p"password" liquibase_db -e "
CREATE TABLE IF NOT EXISTS login (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);"

echo "✅ Login table created successfully!"
echo "🎉 Database initialization completed!"
