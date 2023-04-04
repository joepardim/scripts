#!/bin/bash

# Instalação do Nginx
sudo apt install nginx -y

# Instalação do PHP e extensões
sudo apt install php-fpm php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip -y

# Configuração do PHP
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.4/fpm/php.ini
sudo systemctl restart php7.4-fpm

# Instalação do MariaDB
sudo apt install mariadb-server -y

# Configuração do MariaDB
sudo mysql_secure_installation

# Instalação do phpMyAdmin
sudo apt install phpmyadmin -y

# Configuração do phpMyAdmin
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

# Reinicialização do Nginx
sudo systemctl restart nginx
