# Apache
Apache Web Server in a Docker Container
First of all make your image with this command:

```bash
docker build . -t myappa 
```


then create your container : 
```bash
docker run -it --name apache-web \
-p 8080:80 \
-p 443:443 \
-v /root/apache_config:/config \
-e Hostname=rfinland.site \
-v /root/apache_config/certs:/usr/local/apache2/certs/ \
-v /home/user/website/:/usr/local/apache2/htdocs/ \
myappa
```

if you didn't set your Hostname, by default it'll setted up with localhost
