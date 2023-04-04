#!/bin/bash

# atualiza os pacotes existentes
sudo apt update

# instala o servidor Apache
sudo apt install apache2 -y

# habilita o Apache para iniciar na inicialização do sistema
sudo systemctl enable apache2

# instala o servidor MySQL e PHP
sudo apt install mysql-server php libapache2-mod-php php-mysql -y

# habilita o MySQL para iniciar na inicialização do sistema
sudo systemctl enable mysql

# reinicia o Apache
sudo systemctl restart apache2

# exibe as informações de versão do Apache, PHP e MySQL instalados
echo "Versão do Apache instalada:"
apache2 -v
echo ""
echo "Versão do PHP instalada:"
php -v
echo ""
echo "Versão do MySQL instalada:"
mysql -V
