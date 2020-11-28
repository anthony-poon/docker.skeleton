FROM php:7.4-apache
RUN mkdir /var/www/html/credit-suisse
# https://stackoverflow.com/a/51457728/3118680
ENV APACHE_DOCUMENT_ROOT=/var/www/html

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN echo "xdebug.remote_enable = on" >> "$PHP_INI_DIR/php.ini"
RUN echo "xdebug.remote_host = host.docker.internal" >> "$PHP_INI_DIR/php.ini"
RUN echo "xdebug.remote_autostart = on " >> "$PHP_INI_DIR/php.ini"

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite

WORKDIR /var/www/html/credit-suisse
EXPOSE 80