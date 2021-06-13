#!/bin/sh

if [ ! -f /config/apache.conf ];then  \
  touch /config/apache.conf;
fi;
if [ -z "$(ls -A /usr/local/apache2/certs/)" ]; then \
openssl req -new -newkey rsa:4096 -nodes -sha256 \
    -keyout /usr/local/apache2/certs/privkey.pem -x509 -days 365 -out /usr/local/apache2/certs/cert.pem \
    -subj "/C=FI/ST=Finland/L=Helsinki/O=MyApache/CN=${Hostname:-localhost}" ;
fi;


/usr/local/bin/httpd-foreground
