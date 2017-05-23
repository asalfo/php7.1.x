From php:7.1.5-apache
MAINTAINER Salif Guigma <salif.guigma@gmail.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
      libicu-dev \
      vim \
      git \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* \
      && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
	      php /usr/local/bin/composer self-update \
      && curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony && \
      	chmod a+x /usr/local/bin/symfony \
      && curl http://get.sensiolabs.org/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && \
        chmod a+x /usr/local/bin/php-cs-fixer \
      && curl -sS -o /tmp/icu.tar.gz -L http://download.icu-project.org/files/icu4c/57.1/icu4c-57_1-src.tgz \
      && tar -zxf /tmp/icu.tar.gz -C /tmp \
      && cd /tmp/icu/source \
      && ./configure --prefix=/usr/local \
      && make && make install \
      && docker-php-ext-configure intl --with-icu-dir=/usr/local \
      && docker-php-ext-install pdo pdo_mysql opcache intl sockets mbstring bcmath \
      && a2enmod rewrite \
      && pecl install xdebug \
      && pecl clear-cache \
      && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini \
      && usermod -u 1000 www-data \
      && groupmod -g 1000 www-data \
      && usermod -s /bin/bash www-data \
      && echo "date.timezone = Europe/Madrid" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "short_open_tag = Off" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "memory_limit = 128M" >> $PHP_INI_DIR/conf.d/php.ini
