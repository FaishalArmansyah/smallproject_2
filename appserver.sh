#!/bin/bash
echo "===== Installasi Apache, PHP, & MySQL ====="

echo "===== Step 1 - Install Apache ====="
sudo apt update
sudo apt install -y apache2 apache2-utils
sudo systemctl start apache2 && sudo systemctl enable apache2
echo "===== Step 2 - Install PHP 7.4 ====="
sudo apt install php7.4 libapache2-mod-php7.4 php7.4-mysql php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline -y
sudo a2enmod php7.4
sudo systemctl restart apache2

echo "===== Step 3 - Download App ====="
#git clone https://github.com/FaishalArmansyah/smallproject_2.git
sudo cp -r smallproject_2/sosial-media /var/www/
#sudo chown www-data:www-data /var/www/sosial-media/ -R
sudo cp smallproject_2/sosial-media/sosmed.conf /etc/apache2/sites-available/
sudo cp smallproject_2/sosial-media/servername.conf /etc/apache2/conf-available/
sudo a2enconf servername.conf && sudo a2ensite sosmed.conf && sudo a2dissite 000-default.conf
sudo systemctl restart apache2
echo "===== Completed ====="

echo "===== 4. Installasi MySQL ====="
sudo apt update
sudo apt install mariadb-server mariadb-client -y
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl enable mariadb && sudo systemctl restart mariadb
echo "===== 5. Create DB & UserDB ====="
sudo mysql -u root -e "create database dbsosmed;"
sudo mysql -u root -e "grant all privileges on dbsosmed.* to 'devopscilsy'@'%' identified by '1234567890';"
sudo mysql -u root -e "flush privileges;"
echo "===== 6. Restore DB ====="
mysql -u root dbsosmed < smallproject_2/sosial-media/dump.sql
echo "===== Completed =====" 

#mysql
#mysql -h alamat -u nama-pengguna -p"katasandi" -e "CREATE DATABASE nama-db;"
#mysql -h alamat -u nama-pengguna -p"katasandi" -e "GRANT ALL ON nama-db.* TO 'nama-pengguna'@'%';"
#mysql -h alamat -u nama-pengguna -p"katasandi" -e "FLUSH PRIVILEGES;"
#cd /var/www/website
#mysql -h alamat -u nama-pengguna -p"katasandi" nama-db < dump.sql

