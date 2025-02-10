FROM ghcr.io/nobitacnt-demo/image-php-octane

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    nodejs \
    npm \
  && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["sh", "-c", "composer install && npm install && php artisan octane:start --host 0.0.0.0 --port 80 --watch"]