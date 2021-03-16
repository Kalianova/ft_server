FROM debian:buster

#Install nginx, php utils, MySQL
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y nginx openssl wget
RUN apt-get install -y mariadb-server
RUN apt-get install -y php-fpm php-mysql 

#Add Phpmyadmin
RUN mkdir /var/www/astaryu
RUN mkdir /var/www/astaryu/phpmyadmin
RUN chown -R www-data:www-data /var/www/*
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.7/phpMyAdmin-4.9.7-all-languages.tar.gz
RUN tar -xzf phpMyAdmin-4.9.7-all-languages.tar.gz --strip-components=1 -C /var/www/astaryu/phpmyadmin
RUN rm -rf phpMyAdmin-4.9.7-all-languages.tar.gz
COPY ./srcs/config.inc.php /var/www/astaryu/phpmyadmin

#Add wordpress
RUN mkdir /var/www/astaryu/wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzf latest.tar.gz --strip-components=1 -C /var/www/astaryu/wordpress
RUN rm -rf latest.tar.gz
COPY ./srcs/wp-config.php /var/www/astaryu/wordpress

#Generate ssl sertificate
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
-keyout /etc/nginx/ssl/astaryu.key -out /etc/nginx/ssl/astaryu.pem \
-subj "/C=RU/ST=Moscow/L=Moscow/O=School_21/OU=Astaryu/CN=astaryu"

#Nginx
COPY ./srcs/nginx.conf /etc/nginx/sites-available/default

EXPOSE 80 443

COPY ./srcs/autoindex_on.sh .
COPY ./srcs/autoindex_off.sh .
COPY ./srcs/nginx.conf .
COPY ./srcs/nginx_off.conf .
COPY ./srcs/start_server.sh .
RUN chmod +x start_server.sh
CMD bash start_server.sh