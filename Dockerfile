FROM php:8.3-fpm

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

# Copy the entire application first
COPY . /var/www

# Create necessary directories
RUN mkdir -p /var/www/database \
    /var/www/storage/framework/cache \
    /var/www/storage/framework/sessions \
    /var/www/storage/framework/views \
    /var/www/storage/logs \
    /var/www/bootstrap/cache

# Create .env file if it doesn't exist
RUN if [ ! -f .env ]; then cp .env.example .env; fi

# Install composer dependencies (update to resolve version conflicts)
RUN composer update --no-interaction --no-dev --optimize-autoloader --prefer-stable

# Create SQLite database file
RUN touch /var/www/database/database.sqlite

# Set proper permissions BEFORE running artisan commands
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache \
    && chmod 664 /var/www/database/database.sqlite

# Generate application key
RUN php artisan key:generate --force

# Clear and cache configuration
RUN php artisan config:clear && php artisan config:cache

# Run database migrations
RUN php artisan migrate --force

# Seed the database (optional - comment out if not needed in production)
RUN php artisan db:seed --force || true

# Cache routes and views
RUN php artisan route:cache
RUN php artisan view:cache

# Expose port 8080
EXPOSE 8080

# Start PHP built-in server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]
