#!/bin/bash
echo "===== Step 1 - Install Apache ====="
sudo apt update
sudo apt install -y apache2 apache2-utils mysql-client
sudo systemctl start apache2 && sudo systemctl enable apache2

echo "===== Step 2 - Install PHP 7.4 ====="
sudo apt install php7.4 libapache2-mod-php7.4 php7.4-mysql php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline -y
sudo a2enmod php7.4
sudo systemctl restart apache2

echo "===== Step 3 - Download App ====="
sudo cp -r smallproject_2/sosial-media /var/www/
sed -i 's/localhost/isi-dbserver/g' /var/www/sosial-media/config.php
sudo mkdir /var/log/apache2/sosmed
sudo cp smallproject_2/sosial-media/sosmed.conf /etc/apache2/sites-available/
sudo cp smallproject_2/sosial-media/servername.conf /etc/apache2/conf-available/
sudo a2enconf servername.conf && sudo a2ensite sosmed.conf && sudo a2dissite 000-default.conf
sudo systemctl restart apache2

echo "===== Step 4 - Install s3fs ====="
sudo apt-get install -y automake autotools-dev fuse g++ git libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev make pkg-config
git clone https://github.com/s3fs-fuse/s3fs-fuse.git
cd s3fs-fuse
sudo ./autogen.sh
sudo ./configure --prefix=/usr --with-openssl
sudo make
sudo make install
cd ..
echo AKIAR33JBTGZEXLKM3GQ:kjMKm/mR5PTQEuqh0bl8n0E7x7IQAU9phS+2g6sS > /etc/passwd-s3fs
sudo chmod 640 /etc/passwd-s3fs
sudo mkdir /var/www/sosial-media
sudo s3fs sosmed-img-bucket /var/www/sosial-media/img -o passwd_file=/etc/passwd-s3fs -o url=https://s3.ap-southeast-1.amazonaws.com/ -ouid=1001,gid=1001,allow_other
sudo chmod -R o+rx /var/www/sosial-media/img/*
sudo s3fs sosmed-apachelog-bucket /var/log/apache2/sosmed -o passwd_file=/etc/passwd-s3fs -o url=https://s3.ap-southeast-1.amazonaws.com/ -ouid=1001,gid=1001,allow_other
sudo chmod 640 /var/log/apache2/sosmed/*
sudo systemctl restart apache2

echo "===== 5. create & restore DB MySQL ====="
mysql -h isi-dbserver -u root -p"isi-password" -e "create database dbsosmed;"
mysql -h isi-dbserver -u root -p"isi-password" -e "grant all privileges on dbsosmed.* to 'isi-dbuser'@'%' identified by 'isi-dbpassword';"
mysql -h isi-dbserver -u root -p"isi-password" -e "flush privileges;"
mysql -h isi-dbserver -u isi-dbuser -p"isi-dbpassword" dbsosmed < /var/www/sosial-media/dump.sql

echo "===== Completed =====" 
