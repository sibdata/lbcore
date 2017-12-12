#!/bin/bash

if [ ! -f /root/billing/conf/billing.conf ]
then
  echo "Началась установка биллинга"

  mkdir -p /root/billing/{conf,logs}
  touch /root/billing/logs/lbcore.log
  cp /etc/billing.conf /root/billing/conf/
  sed -i "s|database = mysql://billing:billing@127.0.0.1/billing|database = mysql://$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_HOST/$MYSQL_DATABASE|" /root/billing/conf/billing.conf
  sleep 20

echo "Импорт базы"
/usr/bin/expect<<EOF
    log_user 1
    set timeout 1000
    spawn mysql -u$MYSQL_USER -p $MYSQL_DATABASE -h $MYSQL_HOST -e "source /usr/local/billing/mysql/create.sql;"
    expect "Enter password:"
    send "$MYSQL_PASSWORD\n"
    expect eof
EOF
echo "Импорт базы завершен"

echo "Переносим Web-файлы"
cp -r /usr/local/billing/phpclient/*  /var/www/html/
echo "Web-файлы перенесены"

echo "Даем доступ в базу для web кабинетов для SOAP"
/usr/bin/expect<<EOF
    log_user 1
    set timeout 1000
    spawn mysql -u$MYSQL_USER -p $MYSQL_DATABASE -h $MYSQL_HOST -e "INSERT INTO \`trusted\` (trusted_id, \`trusted_ip\`, \`trusted_mask\`, \`trusted_descr\`) VALUES (2, unhex('00000000000000000000ffffAC000000'), unhex('00000000000000000000ffffFF000000'), 'docker');"
    expect "Enter password:"
    send "$MYSQL_PASSWORD\n"
    expect eof
EOF
echo "Доступ к soap в базе разрешен"

echo "Правим конфиги для доступа к soap"
sed -i "s|<SOAP:address location=\"http://127.0.0.1:34012\"/>|<SOAP:address location=\"http://soap:34012\"/>|" /var/www/html/client2/client/soap/api3.wsdl
sed -i "s|<SOAP:address location=\"http://127.0.0.1:34012\"/>|<SOAP:address location=\"http://soap:34012\"/>|" /var/www/html/admin/soap/api3.wsdl
echo "Доступ к soap в конфигах разрешен"

echo "Установка биллинга завершена"

else
echo "Биллинг уже установлен"
fi


exec "$@"
