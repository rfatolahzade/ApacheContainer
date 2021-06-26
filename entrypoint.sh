#!/bin/sh

if [ ! -f /config/apache.conf ];then  \
  touch /config/apache.conf;
fi;

if [ -z "$(ls -A /usr/local/apache2/certs/)" ]; then \
openssl req -new -newkey rsa:4096 -nodes -sha256 \
    -keyout /usr/local/apache2/certs/privkey.pem -x509 -days 365 -out /usr/local/apache2/certs/cert.pem \
    -subj "/C=FI/ST=Finland/L=Helsinki/O=MyApa/CN=${Hostname:-localhost}" ;
fi;

target_file="/config/default.conf"

if [ ! -f "$target_file" ];then  \
    touch "$target_file" && cat /dev/null > "$target_file"
else
 cat /dev/null > "$target_file";
fi;

if [ -z "${DisableHttptwo}" ]; then \
cat >"$target_file" <<'EOL'
LoadModule http2_module modules/mod_http2.so
Protocols h2 h2c http/1.1
EOL
fi;

replacement="AddOutputFilterByType BROTLI_COMPRESS ${BROTLI_COMPRESS_Vals}"

if [ -n "${BROTLI_COMPRESS_Vals}" ]; then
  echo LoadModule brotli_module modules/mod_brotli.so >> "$target_file"
  echo "${replacement}" >> "$target_file"
fi

echo LoadModule deflate_module modules/mod_deflate.so >> "$target_file"

httpd_file="conf/httpd.conf"

sed -i "s/www.example.com/${Hostname:-localhost}/g"   "$httpd_file";
sed -i "s/#ServerName ${Hostname:-localhost}/ServerName ${Hostname:-localhost}/g"  "$httpd_file";

if [ -n "${Proxy}" ]; then
  cat >>"$target_file" <<'EOL'

<VirtualHost *:443>
    ServerName www.example.com
    ProxyPreserveHost On
    RequestHeader set X-Forwarded-Proto "https"
    RequestHeader set X-Forwarded-Host "www.example.com"
    ProxyPass           / http://YourProxy:Port/ connectiontimeout=240 timeout=1200
    ProxyPassReverse    / http://YourProxy:Port/
</VirtualHost>
EOL
sed -i "s/www.example.com/${Hostname:-localhost}/g"   "$target_file";
sed -i "s/YourProxy:Port/${Proxy}/g"   "$target_file";
else
sed -i "s/www.example.com/${Hostname:-localhost}/g"  conf/extra/httpd-ssl.conf
fi;

/usr/local/bin/httpd-foreground
