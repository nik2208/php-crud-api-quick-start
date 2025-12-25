#!/bin/bash

# Carica le variabili d'ambiente dal file .env
export $(grep -v '^#' .env | xargs)

# Funzione per calcolare il profilo Docker Compose in base al driver
calculate_db_profile() {
    if [ "$PHP_CRUD_API_DRIVER" = "mysql" ]; then
        echo "mysql"
    elif [ "$PHP_CRUD_API_DRIVER" = "pgsql" ]; then
        echo "postgres"
    else
        echo "mysql"  # Default
    fi
}

# Valida il driver del database
if [ "$PHP_CRUD_API_DRIVER" != "mysql" ] && [ "$PHP_CRUD_API_DRIVER" != "pgsql" ]; then
    echo "Errore: PHP_CRUD_API_DRIVER deve essere 'mysql' o 'pgsql'."
    exit 1
fi

# Valida il tool di amministrazione del database
if [ "$DB_ADMIN_TOOL" != "adminer" ] && [ "$DB_ADMIN_TOOL" != "phpmyadmin" ]; then
    echo "Errore: DB_ADMIN_TOOL non valido. Usa 'adminer' o 'phpmyadmin'."
    exit 1
fi

# Verifica che phpmyadmin sia usato solo con MySQL
if [ "$DB_ADMIN_TOOL" = "phpmyadmin" ] && [ "$PHP_CRUD_API_DRIVER" = "pgsql" ]; then
    export DB_ADMIN_TOOL="adminer"
fi

# Calcola il profilo Docker Compose
DB_PROFILE=$(calculate_db_profile)

echo "Arresto dei servizi..."
echo "Database Driver: $PHP_CRUD_API_DRIVER"
echo "Database Profile: $DB_PROFILE"
echo "Admin Tool: $DB_ADMIN_TOOL"
echo ""

docker compose --profile "$DB_PROFILE" --profile "$DB_ADMIN_TOOL" down

if [ $? -eq 0 ]; then
    echo "✅ Servizi arrestati con successo!"
else
    echo "❌ Errore nell'arresto dei servizi."
    exit 1
fi