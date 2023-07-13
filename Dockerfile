# Base image
FROM php:7.2-fpm

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libzip-dev \
    zip \
    unzip \
    git

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy project files
COPY . /var/www/html

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache

# Install project dependencies
RUN composer install --no-dev --no-scripts --no-progress --prefer-dist

# Generate optimized autoload files
#RUN composer dump-autoload --optimize --no-dev --classmap-authoritative

# Clear application cache
#RUN php artisan optimize:clear

# Expose port 9000 for PHP-FPM
EXPOSE 8000

# Start PHP-FPM
CMD ["php-fpm"]