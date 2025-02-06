#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

FROM php:8.3-cli

ARG SUPERVISOR_WORKERS=/var/www/html/workers/*.conf
ENV SUPERVISOR_WORKERS ${SUPERVISOR_WORKERS}
ENV APP_WORKDIR /var/www/html

#
#--------------------------------------------------------------------------
# Software's Installation
#--------------------------------------------------------------------------
#

# Packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    wget \
    libz-dev \
    libpq-dev \
    libssl-dev \
    libmcrypt-dev \
    libzip-dev \
    libpng-dev \
    zip \
    unzip \
    nano \
    supervisor \
    autoconf  \
    libc-dev \
    librdkafka-dev \
    libbrotli-dev \
    && rm -rf /var/lib/apt/lists/*

# PHP extensions
RUN docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    pdo_pgsql \
    zip \
    sockets \
    bcmath \
    gd \
    pcntl \
  && pecl install swoole && docker-php-ext-enable swoole \
  && pecl install rdkafka && docker-php-ext-enable rdkafka \
  && pecl install redis && docker-php-ext-enable redis \
  && pecl install mongodb && docker-php-ext-enable mongodb

# Composer
RUN curl -s https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Jobber
RUN wget https://github.com/dshearer/jobber/releases/download/v1.4.4/jobber_1.4.4-1_amd64.deb -O /tmp/jobber.deb \
    && apt install -f /tmp/jobber.deb \
    && rm /tmp/jobber.deb

#--------------------------------------------------------------------------
# Software's Configuration
#--------------------------------------------------------------------------

COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www/html

ENTRYPOINT ["php", "artisan", "octane:start", "--host", "0.0.0.0", "--port", "80"]