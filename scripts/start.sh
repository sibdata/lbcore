#!/bin/bash

if [ "$(cat /root/billing/installed.txt)" != 1 ]
then
  echo "1" > /root/billing/installed.txt
  mkdir -p /root/billing/{conf,logs}
  cp /etc/billing.conf /root/billing/conf/
  touch /root/billing/logs/lbcore.log
  sed -i "s|database = mysql://billing:billing@127.0.0.1/billing|database = mysql://$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_HOST/$MYSQL_DATABASE|" /root/billing/conf/billing.conf
sleep 20
/usr/bin/expect<<EOF
    log_user 1
    set timeout 1000
    spawn mysql -u$MYSQL_USER -p $MYSQL_DATABASE -h $MYSQL_HOST -e "source /usr/local/billing/mysql/create.sql;"
    expect "Enter password:"
    send "$MYSQL_PASSWORD\n"
    expect eof
EOF
fi
exec "$@"
