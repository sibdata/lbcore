#!/bin/sh

apk --update --no-cache add apache2 py-simplejson php5 php5-soap gd tiff libpng php5-gd php5-mysql ghostscript php5-gmp php5-apache2 php5-json php5-xml php5-dom php5-xmlreader
sed -i "s|max_execution_time = 30|max_execution_time = 3600|" /etc/php5/php.ini \
&& sed -i "s|default_socket_timeout = 60|default_socket_timeout = 3600|" /etc/php5/php.ini \
&& sed -i "s|memory_limit = 128M|memory_limit = 1024M|" /etc/php5/php.ini \
&& sed -i "s|; max_input_vars = 1000|max_input_vars = 2500|" /etc/php5/php.ini \
&& sed -i "s|Listen 80|Listen 0.0.0.0:80|" /etc/apache2/httpd.conf \
&& sed -i "s|date.timezone = UTC|date.timezone = $TZ|" /etc/php5/php.ini
mkdir /run/apache2

cat <<EOF >> /etc/apache2/conf.d/client.conf
Alias /client /usr/local/apache2/htdocs/client2/client/public/
<Directory /usr/local/apache2/htdocs/client2/client/public/>
Options FollowSymLinks
AllowOverride All
Require all granted
</Directory>
EOF

cat <<EOF >> /etc/apache2/conf.d/admin.conf
Alias /admin /usr/local/apache2/htdocs/admin/
<Directory /usr/local/apache2/htdocs/admin/>
Options FollowSymLinks
AllowOverride All
Require all granted
</Directory>
EOF

sed -i "s|#ServerName www.example.com:80|ServerName localhost:80|" /etc/apache2/httpd.conf

echo "ErrorLog /logs/error.log" >> /etc/apache2/httpd.conf

mkdir /logs
touch /logs/error.log
ln -sf /dev/stdout /logs/error.log
