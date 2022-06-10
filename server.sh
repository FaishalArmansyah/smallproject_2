#!/bin/bash
sudo apt-get update
git clone https://github.com/FaishalArmansyah/smallproject_2.git
sed -i 's/isi-dbserver/db-server.cir7gtvctrcn.ap-southeast-1.rds.amazonaws.com/g' smallproject_2/appserver.sh
sed -i 's/isi-password/Password.123!/g' smallproject_2/appserver.sh
sed -i 's/isi-dbuser/devopscilsy/g' smallproject_2/appserver.sh
sed -i 's/isi-dbpassword/1234567890/g' smallproject_2/appserver.sh
sudo chmod 500 smallproject_2/appserver.sh
/bin/bash smallproject_2/appserver.sh
