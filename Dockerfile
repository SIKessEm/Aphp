FROM php:8.0.10-apache AS site
WORKDIR /var/www/html
ADD . /var/www/html/
VOLUME /var/www/html
RUN a2enmod rewrite && a2enmod rewrite remoteip && service apache2 restart
EXPOSE 80
EXPOSE 443

FROM postgres:13.4 AS base
ENV POSTGRES_PASSWORD Aphp-1.0|DevOps\
    POSTGRES_USER SIKessEm\
    POSTGRES_DB aphp\
    PGDATA /var/lib/postgres/data
VOLUME /var/lib/postgres/data
EXPOSE 5432
CMD postgres -c max_connections=300 -c login_min_message=LOG -p 5432

FROM site AS app
RUN apt-get update -yqq && apt-get upgrade -yqq; apt-get install -yqq\
    git\
    vim\
    libpq-dev\
    libcurl4-gnutls-dev\
    libicu-dev libvpx-dev\
    libjpeg-dev libpng-dev\
    libxpm-dev zlib1g-dev\
    libfreetype6-dev\
    libxml2-dev\
    libexpat1-dev\
    libbz2-dev\
    libgmp3-dev\
    libldap2-dev\
    unixodbc-dev\
    libsqlite3-dev\
    libaspell-dev\
    libsnmp-dev\
    libpcre3-dev\
    libtidy-dev\
    libonig-dev\
    libzip-dev
RUN docker-php-ext-install\
    mbstring\
    pdo_pgsql\
    curl\
    intl\
    gd\
    xml\
    zip\
    bz2\
    opcache
COPY --from=composer:2.1.6 /usr/bin/composer* /usr/bin/
RUN composer install --no-dev
