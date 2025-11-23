FROM debian

RUN apt update && apt upgrade -y

RUN apt install -y \
    apt-transport-https \
    lsb-release \
    ca-certificates \
    less \
    wget \
    curl \
    apache2 \
    --no-install-recommends

# Add ondrej sources for old php packages
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# PHP & Extensions
RUN DEBIAN_FRONTEND=noninteractive apt update && apt upgrade -y && apt install -y \
    php7.1 \
    php7.1-bcmath \
    php7.1-curl \
    php7.1-gd \
    php7.1-mcrypt \
    php7.1-mbstring \
    php7.1-mysql \
    php7.1-sqlite3 \
    php7.1-soap \
    php7.1-xml \
    php7.1-zip \
    php7.1-xdebug

COPY conf/docker-php.conf /etc/apache2/conf-available/
COPY conf/dir.conf /etc/apache2/mods-available/
COPY conf/php7.1.conf /etc/apache2/mods-available/

RUN a2enconf docker-php && a2enmod rewrite

STOPSIGNAL WINCH
WORKDIR /var/www/html

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
