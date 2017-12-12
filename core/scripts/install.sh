#!/bin/bash

yum install wget epel-release -y -q
mkdir -p /root/billing
yum-config-manager --add-repo https://pkgs.lanbilling.ru/rpm/lb20/7/main/736962646174615f32/ef40a99ce87c941658eb5fc30461b49f33898ca0/lanbilling-2.0-release.repo
rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
yum install mysql expect lbcore* -y -q
sed -i "s|logfile = ./lbcore.log|logfile = /root/billing/logs/lbcore.log|" /etc/billing.conf
sed -i "s|listen = 127.0.0.1:1502|listen = 0.0.0.0:1502|" /etc/billing.conf
ln -sf /dev/stdout /root/billing/logs/lbcore.log
