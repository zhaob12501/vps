#!/bin/bash

# 第一步
while
do
    if wget -P /usr/local/src/ --no-check-certificate https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-server_5.7.20-1debian7_amd64.deb-bundle.tar
    then
        break
    fi
done

# 第二步
tar vxf mysql-server_5.7.20-1debian7_amd64.deb-bundle.tar

# 第三步
# apt-get --fix-broken install -y
# apt-get update -y
# apt-get upgrade -y
# apt-get install libnuma1 -y

# 第四步
dpkg -i mysql-common_5.7.20-1debian7_amd64.deb
dpkg-preconfigure mysql-community-server_5.7.20-1debian7_amd64.deb

# 第五步
dpkg -i libmysqlclient20_5.7.20-1debian7_amd64.deb 
dpkg -i libmysqlclient-dev_5.7.20-1debian7_amd64.deb
dpkg -i libmysqld-dev_5.7.20-1debian7_amd64.deb 
dpkg -i mysql-community-client_5.7.20-1debian7_amd64.deb 
dpkg -i mysql-client_5.7.20-1debian7_amd64.deb 
dpkg -i mysql-common_5.7.20-1debian7_amd64.deb

# 第六步
apt-get -f install -y
apt-get -f install libmecab2 -y

# 第七步
dpkg -i mysql-community-server_5.7.20-1debian7_amd64.deb 
dpkg -i mysql-server_5.7.20-1debian7_amd64.deb

# 第八步
mysql -u root -p
