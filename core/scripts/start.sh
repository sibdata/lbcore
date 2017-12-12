#!/bin/bash

if [ ! -f /root/billing/conf/billing.conf ]
then
  echo "Началась установка биллинга"

  echo "Переносим Web-файлы"
  cp -r /usr/local/billing/phpclient/*  /var/www/html/
  echo "Web-файлы перенесены"

  echo "Создаем конфиг"
  mkdir -p /root/billing/conf
  cp /etc/billing.conf /root/billing/conf/
  sed -i "s|database = mysql://billing:billing@127.0.0.1/billing|database = mysql://$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_HOST/$MYSQL_DATABASE|" /root/billing/conf/billing.conf
  echo "Конфиг создан"

  echo "Правим конфиги для доступа к soap"
  sed -i "s|<SOAP:address location=\"http://127.0.0.1:34012\"/>|<SOAP:address location=\"http://soap:34012\"/>|" /var/www/html/client2/client/soap/api3.wsdl
  sed -i "s|<SOAP:address location=\"http://127.0.0.1:34012\"/>|<SOAP:address location=\"http://soap:34012\"/>|" /var/www/html/admin/soap/api3.wsdl
  echo "Доступ к soap в конфигах разрешен"

  sleep 20
  echo "Импорт базы"
  mysql -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -h $MYSQL_HOST -e "source /usr/local/billing/mysql/create.sql;"
  echo "Импорт базы завершен"

  echo "Даем доступ в базу для web кабинетов для SOAP"
  mysql -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -h $MYSQL_HOST -e "INSERT INTO \`trusted\` (trusted_id, \`trusted_ip\`, \`trusted_mask\`, \`trusted_descr\`) VALUES (2, unhex('00000000000000000000ffffAC000000'), unhex('00000000000000000000ffffFF000000'), 'docker');"
  echo "Доступ к soap в базе разрешен"

echo "Установка биллинга завершена"
else
echo "Биллинг уже установлен"
fi


exec "$@"
