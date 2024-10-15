FROM php:8.1-fpm

RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    curl \
    && docker-php-ext-install zip

RUN docker-php-ext-install pdo pdo_mysql mysqli

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

# Scarica api.php all'avvio del container
CMD curl -o /var/www/html/api.php https://raw.githubusercontent.com/mevdschee/php-crud-api/main/api.php && \
    chown www-data:www-data /var/www/html/api.php && \
    chmod 644 /var/www/html/api.php && \
    php-fpm

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Use the default PHP production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"