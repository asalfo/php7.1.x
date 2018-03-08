From php:7.1.5-apache
MAINTAINER Salif Guigma <salif.guigma@gmail.com>

RUN   curl -sL https://deb.nodesource.com/setup_8.x | bash - \
      && apt-get update && apt-get install -y --no-install-recommends \
      libicu-dev \
      zlib1g-dev \
      build-essential \
      libpng12-dev \
      libjpeg-dev \
      libfreetype6-dev \
      vim \
      git \
      wget \
      clang \
      nodejs \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* \
      && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
	    && php /usr/local/bin/composer self-update \
      && curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony \
      && chmod a+x /usr/local/bin/symfony \
      && curl -sS -o /tmp/icu.tar.gz -L http://download.icu-project.org/files/icu4c/57.1/icu4c-57_1-src.tgz \
      && tar -zxf /tmp/icu.tar.gz -C /tmp \
      && cd /tmp/icu/source \
      && ./configure --prefix=/usr/local \
      && make && make install \
      && docker-php-ext-configure intl --with-icu-dir=/usr/local \
      && docker-php-ext-install zip pdo pdo_mysql  mysqli  opcache intl sockets mbstring bcmath \
      && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
      && docker-php-ext-install -j$(nproc) gd \
      && a2enmod rewrite \
      && pecl install xdebug \
      && docker-php-ext-enable xdebug \
      && pecl install apcu \
      && pecl clear-cache \
      && version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
      && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
      && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
      && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
      && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
      && cd /tmp && wget https://phar.phpunit.de/phpunit-6.1.phar && chmod +x phpunit-6.1.phar && mv phpunit-6.1.phar /usr/local/bin/phpunit \
      && echo "date.timezone = Europe/Madrid" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "short_open_tag = Off" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "memory_limit = 256M" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "log_errors = On" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "error_log = /dev/stderr" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "short_open_tag = Off" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "xdebug.remote_enable=On" >> $PHP_INI_DIR/conf.d/xdebug.ini \
      && echo "xdebug.remote_autostart=1" >> $PHP_INI_DIR/conf.d/xdebug.ini \
      && echo "xdebug.remote_port=9000" >> $PHP_INI_DIR/conf.d/xdebug.ini \
      && usermod -u 1000 www-data \
      && groupmod -g 1000 www-data \
      && usermod -s /bin/bash www-data \
      && rm -rf /tmp/*
