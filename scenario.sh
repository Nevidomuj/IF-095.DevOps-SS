#!/bin/bash
MAINDB="moodle"
USERDB="moodleuser"
PASSWDDB="moodlepassword"
sudo yum -y update

# install PHP 7.0
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum -y install yum-utils
sudo yum-config-manager --enable remi-php70
sudo yum -y install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo php-xml php-intl php-mbstring php-xmlrpc php-soap

#Install Apache
sudo yum -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd

#install DB
sudo yum -y install mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql -e "SET GLOBAL character_set_server = 'utf8mb4';"
sudo mysql -e "SET GLOBAL innodb_file_format = 'BARRACUDA';"
sudo mysql -e "SET GLOBAL innodb_large_prefix = 'ON';"
sudo mysql -e "SET GLOBAL innodb_file_per_table = 'ON';"
sudo mysql -e "CREATE DATABASE ${MAINDB};"
sudo mysql -e "CREATE USER '${USERDB}'@'localhost' IDENTIFIED BY '${PASSWDDB}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${USERDB}'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

#Install App
sudo yum -y install wget
sudo wget https://download.moodle.org/download.php/direct/stable36/moodle-latest-36.tgz
tar -zxvf moodle-latest-36.tgz
sudo cp -R moodle /var/www/html
sudo /usr/bin/php /var/www/html/moodle/admin/cli/install.php --wwwroot=http://192.168.56.110/moodle --dataroot=/var/moodledata --dbtype=mariadb --dbname=dbname --dbuser=mykola --dbpass=123456 --fullname="Moodle" --adminpass=admin  --shortname="Moodle" --non-interactive --agree-license
sudo chmod a+r /var/www/html/moodle/config.php
sudo chcon -R -t httpd_sys_rw_content_t /var/moodledata