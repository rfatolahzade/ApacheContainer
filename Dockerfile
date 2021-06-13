FROM httpd

RUN apt-get update
RUN apt-get install nano iputils-ping wget curl -y

RUN echo 'Include /config/apache.conf' >> conf/httpd.conf

RUN sed -i \
        -e 's/conf\/server.key/certs\/privkey.pem/' \
        -e 's/conf\/server.crt/certs\/cert.pem/' \
        conf/extra/httpd-ssl.conf

RUN sed -i \
        -e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
        -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_http2.so\)/\1/' \
        conf/httpd.conf

VOLUME /usr/local/apache2/certs

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
