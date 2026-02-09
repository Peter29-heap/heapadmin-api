FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    sqlite3 \
    libsqlite3-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_sqlite pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
RUN chown -R www-data:www-data /var/www

# Install composer dependencies
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Create SQLite database file
RUN touch /var/www/database/database.sqlite

# Set permissions for storage and bootstrap cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Generate application key
RUN php artisan key:generate --force

# Run database migrations
RUN php artisan migrate --force

# Seed the database
RUN php artisan db:seed --force

# Cache configuration
RUN php artisan config:cache
RUN php artisan route:cache

# Expose port 8080
EXPOSE 8080

# Start PHP built-in server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]
