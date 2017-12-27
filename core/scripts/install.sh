#!/bin/bash

yum install epel-release -y -q
mkdir -p /root/billing
yum-config-manager --add-repo https://pkgs.lanbilling.ru/rpm/lb20/7/main/736962646174615f32/ef40a99ce87c941658eb5fc30461b49f33898ca0/lanbilling-2.0-release.repo
rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
yum --enablerepo="lanbilling-2.0-hotfix" install lbcore* -y -q
yum install mysql expect -y -q
yum clean all -y -q
mkdir /logs
touch /logs/lbcore.log
sed -i "s|logfile = ./lbcore.log|logfile = /logs/lbcore.log|" /etc/billing.conf
sed -i "s|listen = 127.0.0.1:1502|listen = 0.0.0.0:1502|" /etc/billing.conf
ln -sf /dev/stdout /logs/lbcore.log
