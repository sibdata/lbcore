#!/bin/sh

if [ ! -d /usr/local/apache2/htdocs/client2 ]
then
echo "Установка Web-части"
sleep 120
chown -R apache. /usr/local/apache2/htdocs/client2/client/runtime
chown -R apache. /usr/local/apache2/htdocs/client2/client/public/assets
echo "Установка Web-части завершена"
else
chown -R apache. /usr/local/apache2/htdocs/client2/client/runtime
chown -R apache. /usr/local/apache2/htdocs/client2/client/public/assets
echo "Web-часть установлена"
fi
httpd -D FOREGROUND
