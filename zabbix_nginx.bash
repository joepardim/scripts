#!/bin/bash

# Atualiza o sistema operacional
sudo apt-get update
sudo apt-get upgrade -y

# Instala os pré-requisitos para o Zabbix, Nginx e MariaDB
sudo apt-get install -y nginx mariadb-server php-fpm php-mysql php-gd php-mbstring php-xml php-bcmath wget

# Configura o servidor web Nginx
sudo echo "server {
    listen 80;
    server_name seu_dominio.com;

    root /usr/share/zabbix;
    index index.php;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}" > /etc/nginx/sites-available/zabbix.conf

sudo ln -s /etc/nginx/sites-available/zabbix.conf /etc/nginx/sites-enabled/

sudo rm /etc/nginx/sites-enabled/default

sudo systemctl restart nginx

# Cria o banco de dados e o usuário para o Zabbix
sudo mysql -u root -p -e "CREATE DATABASE zabbix CHARACTER SET UTF8 COLLATE UTF8_BIN;
GRANT ALL ON zabbix.* TO 'zabbix'@'localhost' IDENTIFIED BY 'sua_senha';"

# Adiciona o repositório do Zabbix e instala o Zabbix
sudo wget https://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.4-1+ubuntu20.04_all.deb
sudo dpkg -i zabbix-release_5.4-1+ubuntu20.04_all.deb
sudo apt-get update
sudo apt-get install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent

# Configura o Zabbix
sudo sed -i "s/# DBPassword=/DBPassword=sua_senha/g" /etc/zabbix/zabbix_server.conf
sudo sed -i "s/# DBHost=localhost/DBHost=localhost/g" /etc/zabbix/zabbix_server.conf

# Inicia e habilita os serviços necessários
sudo systemctl start nginx
sudo systemctl start php7.4-fpm
sudo systemctl start mariadb
sudo systemctl start zabbix-server zabbix-agent
sudo systemctl enable nginx
sudo systemctl enable php7.4-fpm
sudo systemctl enable mariadb
sudo systemctl enable zabbix-server zabbix-agent

# Abre o firewall para o tráfego HTTP e HTTPS
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'

# Limpa o cache e reinicia o servidor
sudo apt-get clean
sudo apt-get autoclean
sudo apt-get autoremove -y
sudo reboot
