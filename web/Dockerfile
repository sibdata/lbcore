FROM alpine

MAINTAINER Sergey Ustyuzhanin SibData Company <dir@sibdata.ru>

ENV TZ Asia/Novosibirsk

RUN apk --update --no-cache add apache2 py-simplejson php5 php5-soap gd tiff libpng php5-gd php5-mysql ghostscript php5-gmp php5-apache2

RUN sed -i "s|max_execution_time = 30|max_execution_time = 3600|" /etc/php5/php.ini \
&& sed -i "s|default_socket_timeout = 60|default_socket_timeout = 3600|" /etc/php5/php.ini \
&& sed -i "s|memory_limit = 128M|memory_limit = 1024M|" /etc/php5/php.ini \
&& sed -i "s|; max_input_vars = 1000|max_input_vars = 2500|" /etc/php5/php.ini

RUN sed -i "s|date.timezone = UTC|date.timezone = $TZ|" /etc/php5/php.ini

RUN mkdir /run/apache2

COPY scripts/ /

RUN /install.sh

EXPOSE 80

ENTRYPOINT ["/start.sh"]

#CMD ["/usr/sbin/httpd","-D","FOREGROUND"]