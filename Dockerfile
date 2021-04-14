FROM debian:buster

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install wget

RUN apt-get -y install nginx

RUN apt-get -y install mariadb-server

RUN apt-get -y install php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring

COPY ./srcs/default /etc/nginx/sites-available/default

COPY ./srcs/wp-config.php ./tmp/wp-config.php

WORKDIR /var/www/html/
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin
COPY ./srcs/config.inc.php phpmyadmin

RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz
RUN mv /tmp/wp-config.php /var/www/html/wordpress

RUN openssl req -x509 -nodes -days 365 -subj "/C=FR/ST=France/L=Paris/O=42/CN=42" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

RUN chown -R www-data:www-data *
RUN chmod -R 755 /var/www/*

RUN mv /var/www/html/index.nginx-debian.html /var/www/html/index.nginx.html

RUN mkdir /var/www/tmp
COPY ./srcs/index.html /var/www/tmp
COPY ./srcs/init.sh /tmp
CMD bash /tmp/init.sh