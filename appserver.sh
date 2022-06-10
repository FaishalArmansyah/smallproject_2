#!/bin/bash
echo "===== Step 1 - Install Apache ====="
sudo apt update
sudo apt install -y apache2 apache2-utils
sudo systemctl start apache2 && sudo systemctl enable apache2

echo "===== Step 2 - Install PHP 7.4 ====="
sudo apt install php7.4 libapache2-mod-php7.4 php7.4-mysql php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline -y
sudo a2enmod php7.4
sudo systemctl restart apache2

echo "===== Step 3 - Download App ====="
sudo cp -r smallproject_2/sosial-media /var/www/
sudo cp smallproject_2/sosial-media/sosmed.conf /etc/apache2/sites-available/
sudo cp smallproject_2/sosial-media/servername.conf /etc/apache2/conf-available/
sudo a2enconf servername.conf && sudo a2ensite sosmed.conf && sudo a2dissite 000-default.conf
sudo systemctl restart apache2

echo "===== 4. create & restore DB MySQL ====="
mysql -h dbserver.cir7gtvctrcn.ap-southeast-1.rds.amazonaws.com -u root -p"Password.123!" -e "create database dbsosmed;"
mysql -h dbserver.cir7gtvctrcn.ap-southeast-1.rds.amazonaws.com -u root -p"Password.123!" -e "grant all privileges on dbsosmed.* to 'devopscilsy'@'%' identified by '1234567890';"
mysql -h dbserver.cir7gtvctrcn.ap-southeast-1.rds.amazonaws.com -u root -p"Password.123!" -e "flush privileges;"

echo "===== 5. Restore DB ====="
mysql -h dbserver.cir7gtvctrcn.ap-southeast-1.rds.amazonaws.com -u root -p"Password.123!" dbsosmed < smallproject_2/sosial-media/dump.sql

echo "===== Completed =====" 
