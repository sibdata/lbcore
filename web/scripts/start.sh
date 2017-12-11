#!/bin/sh

sleep 120

chown -R apache. /usr/local/apache2/htdocs/client2/client/runtime
chown -R apache. /usr/local/apache2/htdocs/client2/client/public/assets

httpd -D FOREGROUND
