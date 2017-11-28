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
cp -r /usr/local/billing/phpclient/*  /var/www/html/

## Даем доступ в базу для web кабинетов для SOAP
/usr/bin/expect<<EOF
    log_user 1
    set timeout 1000
    spawn mysql -u$MYSQL_USER -p $MYSQL_DATABASE -h $MYSQL_HOST -e "INSERT INTO \`trusted\` (trusted_id, \`trusted_ip\`, \`trusted_mask\`, \`trusted_descr\`) VALUES (2, unhex('00000000000000000000ffff0A000000'), unhex('00000000000000000000ffffFF000000'), 'web-server');"
    expect "Enter password:"
    send "$MYSQL_PASSWORD\n"
    expect eof
EOF

/usr/bin/expect<<EOF
    log_user 1
    set timeout 1000
    spawn mysql -u$MYSQL_USER -p $MYSQL_DATABASE -h $MYSQL_HOST -e "INSERT INTO \`trusted\` (trusted_id, \`trusted_ip\`, \`trusted_mask\`, \`trusted_descr\`) VALUES (3, unhex('00000000000000000000ffff0'), unhex('00000000000000000000ffff0'), 'web-server');"
    expect "Enter password:"
    send "$MYSQL_PASSWORD\n"
    expect eof
EOF

sed -i "s|<SOAP:address location=\"http://127.0.0.1:34012\"/>|<SOAP:address location=\"http://10.2.3.4:34012\"/>|" /var/www/html/client2/client/soap/api3.wsdl
sed -i "s|<SOAP:address location=\"http://127.0.0.1:34012\"/>|<SOAP:address location=\"http://10.2.3.4:34012\"/>|" /var/www/html/admin/soap/api3.wsdl

fi


exec "$@"
