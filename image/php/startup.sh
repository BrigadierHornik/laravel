#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
#set -e

# Define working directory
WORKDIR=/app

# 1. Install/Update Composer Dependencies (Optional but recommended)
# Check if vendor directory exists. If not, run composer install.
# You might adjust this logic based on your specific needs (e.g., always run install)
if [ ! -d "vendor" ]; then
    echo "Vendor directory not found. Installing dependencies..."
    if [ "$APP_ENV" == "production" ]; then
        echo "Running composer install for production..."
        composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader
    else
        echo "Running composer install for development..."
        # Still use --no-interaction in Docker, even for dev
        composer install --no-interaction --prefer-dist
    fi
    echo "Composer dependencies installed."
# else
    # Optional: Consider if you ALWAYS want to run install, e.g., for CI consistency
    # echo "Vendor directory exists. Skipping composer install."
fi

echo "Updating .env variables from Docker environment..."

# Define the variables you want to update
ENV_VARS="DB_CONNECTION DB_HOST DB_PORT DB_DATABASE DB_USERNAME DB_PASSWORD"

# Loop through each variable and update it in the .env file
for VAR in $ENV_VARS; do
    VALUE_FROM_ENV="${!VAR}" # Get the value
    # Escape characters special to sed's RHS: &, \, and the delimiter (| in this case)
    ESCAPED_VALUE=$(printf '%s' "$VALUE_FROM_ENV" | sed -e 's/[&\|]/\\&/g')
    # Check if variable exists and update or append
    if grep -q "^$VAR=" .env; then
         # Use | as delimiter for sed
        sed -i "s|^$VAR=.*|$VAR=$ESCAPED_VALUE|" .env
    else
        echo "$VAR=$ESCAPED_VALUE" >> .env
    fi
done

echo ".env variables updated."

# 5. Production optimization
if [ "$APP_ENV" == "production" || "$APP_ENV" == "prod"]; then
    echo "Production environment detected. Optimizing Laravel..."
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    echo "Laravel optimization complete."
else
    echo "Development environment detected. Skipping production optimizations."
    php artisan config:clear
    php artisan route:clear
    php artisan view:clear
fi

# 4. Run Database Migrations (Optional but common)
# Using --force to run in non-interactive mode
echo "Running database migrations..."
php artisan migrate --force
echo "Database migrations complete."

# 5. Optimize Laravel (Optional - Be cautious with caching config/routes)
# Caching config means .env changes and Docker env vars won't be read until cache is cleared
# Uncomment if you understand the implications and need the performance boost


# 6. Fix Permissions (If needed, depends on your base image user)
# If your web server/php-fpm runs as www-data, ensure it owns storage and bootstrap/cache
# chown -R www-data:www-data storage bootstrap/cache

# 7. Execute the main container command (passed from CMD in Dockerfile)
# "$@" allows arguments passed to the entrypoint script (like the CMD) to be executed
echo "Starting the main application process..."

# Execute the original command
exec "$@"