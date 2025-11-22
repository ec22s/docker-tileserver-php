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
    php5.6 \
    php5.6-bcmath \
    php5.6-curl \
    php5.6-gd \
    php5.6-mcrypt \
    php5.6-mbstring \
    php5.6-mysql \
    php5.6-sqlite3 \
    php5.6-soap \
    php5.6-xml \
    php5.6-zip \
    php5.6-xdebug

COPY conf/docker-php.conf /etc/apache2/conf-available/
COPY conf/dir.conf /etc/apache2/mods-available/
COPY conf/php5.6.conf /etc/apache2/mods-available/

RUN a2enconf docker-php && a2enmod rewrite

STOPSIGNAL WINCH
WORKDIR /var/www/html

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
