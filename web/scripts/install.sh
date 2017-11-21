#!/bin/sh

cat <<EOF >> /etc/apache2/httpd.conf
Alias /client /usr/local/apache2/htdocs/client2/client/public/
<Directory /usr/local/apache2/htdocs/client2/client/public/>
Options FollowSymLinks
AllowOverride All
Require all granted
</Directory>
EOF

cat <<EOF >> /etc/apache2/httpd.conf
Alias /admin /usr/local/apache2/htdocs/admin/
<Directory /usr/local/apache2/htdocs/admin/>
Options FollowSymLinks
AllowOverride All
Require all granted
</Directory>
EOF
