FROM ubuntu:24.04

WORKDIR /app
# Install PHP and required extensions
RUN apt-get update && \
    apt-get install -y software-properties-common curl git unzip && \
    add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    apt-get install -y \
        php8.4-cli \
        php8.4-common \
        php8.4-fpm \
        php8.4-zip \
        php8.4-mbstring \
        php8.4-curl \
        php8.4-xml \
        php8.4-tokenizer \
        php8.4-pdo \
        php8.4-mysql
# Installing composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the startup script
COPY startup.sh /tmp/startup.sh

RUN sed -i 's/;pm.status_listen = 127.0.0.1:9001/pm.status_listen = 0.0.0.0:9000/g' /etc/php/8.4/fpm/pool.d/www.conf

ENTRYPOINT [ "/tmp/startup.sh" ]

CMD [ "php-fpm8.4", "-F" ]