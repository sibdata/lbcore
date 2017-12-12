#!/bin/sh

if [ ! -d /usr/local/apache2/htdocs/client2 ]
then
echo "Установка Web-части"
sleep 10
echo "Установка Web-части завершена"
else
echo "Web-часть уже установлена"
fi

chown -R apache. /usr/local/apache2/htdocs/client2/client/runtime
chown -R apache. /usr/local/apache2/htdocs/client2/client/public/assets

httpd -D FOREGROUND
