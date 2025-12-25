#!/bin/bash
set -e

echo "🚀 FrankenPHP Container Startup"
echo "=================================================="
echo "Database Driver: $PHP_CRUD_API_DRIVER"
echo "Database Address: $PHP_CRUD_API_ADDRESS"
echo "Database Port: $PHP_CRUD_API_PORT"
echo "=================================================="

# Funzione per testare la connessione al database
wait_for_database() {
    local max_attempts=30
    local attempt=1
    
    if [ "$PHP_CRUD_API_DRIVER" = "mysql" ]; then
        echo ""
        echo "⏳ Waiting for MySQL to be ready..."
        while [ $attempt -le $max_attempts ]; do
            if nc -z "$PHP_CRUD_API_ADDRESS" "$PHP_CRUD_API_PORT" 2>/dev/null; then
                echo "✅ MySQL is ready! (attempt $attempt/$max_attempts)"
                return 0
            fi
            echo "   Attempt $attempt/$max_attempts: Waiting for MySQL..."
            sleep 2
            attempt=$((attempt + 1))
        done
        echo "❌ MySQL failed to start after ${max_attempts} attempts"
        return 1
    
    elif [ "$PHP_CRUD_API_DRIVER" = "pgsql" ]; then
        echo ""
        echo "⏳ Waiting for PostgreSQL to be ready..."
        while [ $attempt -le $max_attempts ]; do
            if pg_isready -h "$PHP_CRUD_API_ADDRESS" -p "$PHP_CRUD_API_PORT" -U "$PHP_CRUD_API_USERNAME" &>/dev/null; then
                echo "✅ PostgreSQL is ready! (attempt $attempt/$max_attempts)"
                return 0
            fi
            echo "   Attempt $attempt/$max_attempts: Waiting for PostgreSQL..."
            sleep 2
            attempt=$((attempt + 1))
        done
        echo "❌ PostgreSQL failed to start after ${max_attempts} attempts"
        return 1
    else
        echo "❌ Unknown database driver: $PHP_CRUD_API_DRIVER"
        return 1
    fi
}

# Attendi il database
if ! wait_for_database; then
    echo ""
    echo "❌ Database connection failed!"
    echo "   Driver: $PHP_CRUD_API_DRIVER"
    echo "   Address: $PHP_CRUD_API_ADDRESS:$PHP_CRUD_API_PORT"
    echo "   Username: $PHP_CRUD_API_USERNAME"
    exit 1
fi

echo ""
echo "=================================================="
echo "✅ Database is ready! Starting FrankenPHP..."
echo "=================================================="
echo ""

# Generate Caddyfile from template with environment variables
envsubst '${CONTAINERS_NAME_SUFFIX}' < /app/Caddyfile.template > /app/Caddyfile

# FrankenPHP usa Caddyfile per la configurazione
exec frankenphp run -c /app/Caddyfile

