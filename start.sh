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

# Funzione per calcolare l'indirizzo del database in base al driver
calculate_db_address() {
    if [ "$PHP_CRUD_API_DRIVER" = "mysql" ]; then
        echo "mysql_treeqlqs-${CONTAINERS_NAME_SUFFIX}"
    elif [ "$PHP_CRUD_API_DRIVER" = "pgsql" ]; then
        echo "postgres_treeqlqs-${CONTAINERS_NAME_SUFFIX}"
    else
        echo "mysql_treeqlqs-${CONTAINERS_NAME_SUFFIX}"  # Default
    fi
}

# Funzione per calcolare la porta del database in base al driver
calculate_db_port() {
    if [ "$PHP_CRUD_API_DRIVER" = "mysql" ]; then
        echo "3306"
    elif [ "$PHP_CRUD_API_DRIVER" = "pgsql" ]; then
        echo "5432"
    else
        echo "3306"  # Default
    fi
}

# Funzione per calcolare la porta del DB admin tool
calculate_db_admin_port() {
    if [ "$DB_ADMIN_TOOL" = "adminer" ]; then
        echo "8080"
    elif [ "$DB_ADMIN_TOOL" = "phpmyadmin" ]; then
        echo "80"
    else
        echo "80"  # Valore di default
    fi
}

# Calcola i valori automaticamente se non sono stati impostati correttamente
# Permette di lasciare queste variabili vuote nel .env per evitare confusione
if [ -z "$PHP_CRUD_API_ADDRESS" ] || [ "$PHP_CRUD_API_ADDRESS" = "mysql_treeqlqs-php-quick-start" ] || [ "$PHP_CRUD_API_ADDRESS" = "postgres_treeqlqs-php-quick-start" ]; then
    PHP_CRUD_API_ADDRESS=$(calculate_db_address)
fi

if [ -z "$PHP_CRUD_API_PORT" ] || [ "$PHP_CRUD_API_PORT" = "3306" ] || [ "$PHP_CRUD_API_PORT" = "5432" ]; then
    PHP_CRUD_API_PORT=$(calculate_db_port)
fi

if [ -z "$ADMINER_DEFAULT_SERVER" ] || [ "$ADMINER_DEFAULT_SERVER" = "mysql_treeqlqs-php-quick-start" ] || [ "$ADMINER_DEFAULT_SERVER" = "postgres_treeqlqs-php-quick-start" ]; then
    ADMINER_DEFAULT_SERVER=$(calculate_db_address)
fi

export PHP_CRUD_API_ADDRESS
export PHP_CRUD_API_PORT
export ADMINER_DEFAULT_SERVER

# Calcola la porta del DB admin tool
DB_ADMIN_PORT=$(calculate_db_admin_port)
export DB_ADMIN_PORT

# Calcola il profilo Docker Compose
DB_PROFILE=$(calculate_db_profile)
export DB_PROFILE

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
    echo "Avviso: PhpMyAdmin funziona solo con MySQL. Passiamo ad Adminer per PostgreSQL..."
    export DB_ADMIN_TOOL="adminer"
fi

# Costruisce i profili Docker Compose
echo "Avvio dei servizi..."
echo "Database Driver: $PHP_CRUD_API_DRIVER"
echo "Database Profile: $DB_PROFILE"
echo "Admin Tool: $DB_ADMIN_TOOL"
echo "Docker Compose Profiles: --profile $DB_PROFILE --profile $DB_ADMIN_TOOL"
echo ""

docker compose --profile "$DB_PROFILE" --profile "$DB_ADMIN_TOOL" up -d --build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Servizi avviati con successo!"
    echo ""
    echo "🌐 API disponibile su: $SERVER_NAME"
    echo "📊 Admin disponibile su: ${SERVER_NAME}dbadmin/"
    echo "📖 Swagger disponibile su: ${SERVER_NAME}swagger/"
    
    if [ "$PHP_CRUD_API_DRIVER" = "mysql" ]; then
        echo ""
        echo "💾 MySQL:"
        echo "   Host: mysql_treeqlqs-$CONTAINERS_NAME_SUFFIX"
        echo "   Port: 3306"
    else
        echo ""
        echo "🐘 PostgreSQL:"
        echo "   Host: postgres_treeqlqs-$CONTAINERS_NAME_SUFFIX"
        echo "   Port: 5432"
    fi
else
    echo "❌ Errore nell'avvio dei servizi."
    exit 1
fi
