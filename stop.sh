#!/bin/bash

# Carica le variabili d'ambiente dal file .env
export $(grep -v '^#' .env | xargs)

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

# Calcola la porta del DB admin tool
DB_ADMIN_PORT=$(calculate_db_admin_port)
export DB_ADMIN_PORT

# Verifica quale tool di amministrazione del database è stato selezionato
if [ "$DB_ADMIN_TOOL" = "adminer" ]; then
    echo "Arresto dei servizi con Adminer..."
    docker compose --profile adminer down
elif [ "$DB_ADMIN_TOOL" = "phpmyadmin" ]; then
    echo "Arresto dei servizi con PhpMyAdmin..."
    docker compose --profile phpmyadmin down
else
    echo "Errore: DB_ADMIN_TOOL non valido. Usa 'adminer' o 'phpmyadmin'."
    exit 1
fi

echo "Servizi avviati con successo!"