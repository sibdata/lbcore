#!/bin/sh

sleep 120

chown -R apache. /usr/local/apache2/htdocs/client2/client/runtime
chown -R apache. /usr/local/apache2/htdocs/client2/client/public/assets

#sed -i "s|<SOAP:address location=\"http://127.0.0.1:34012\"/>|<SOAP:address location=\"http://10.2.3.4:34012\"/>|" /usr/local/apache2/htdocs/client2/client/soap/api3.wsdl
#sed -i "s|<SOAP:address location=\"http://127.0.0.1:34012\"/>|<SOAP:address location=\"http://10.2.3.4:34012\"/>|" /usr/local/apache2/htdocs/admin/soap/api3.wsdl
httpd -D FOREGROUND
