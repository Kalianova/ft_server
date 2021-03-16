#!/bin/bash
service nginx start
service mysql start
service php7.3-fpm start

#Create database
service mysql start
mysql -e "CREATE DATABASE astaryu_database;"
mysql -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY '123';"
mysql -e "GRANT ALL PRIVILEGES ON astaryu_database.* TO 'admin'@'localhost' WITH GRANT OPTION;"
mysql -e "UPDATE mysql.user SET plugin='mysql_native_password' WHERE user='admin';"
mysql -e "FLUSH PRIVILEGES;"

bash
