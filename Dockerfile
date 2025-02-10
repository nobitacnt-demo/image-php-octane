FROM ghcr.io/nobitacnt-demo/image-php-octane as base
FROM base AS install
COPY . .
RUN composer install --no-ansi --no-dev --no-interaction --no-plugins --no-progress --no-scripts --optimize-autoloader

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    nodejs \
    npm \
  && rm -rf /var/lib/apt/lists/* \
RUN npm install

FROM base
COPY --from=install /var/www/html .

# Set up permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage