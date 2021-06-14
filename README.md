# Apache
Apache Web Server in a Docker Container
First of all make your image with this command:

```bash
docker build . -t myappa 
```

One of the amazing things about the Docker ecosystem is that there are tens of standard containers that you can easily download and use. we will instantiate an Apache latest container named apache-web, detached from the current terminal. We will use an image called httpd:latest from Docker Hub.

Our plan is to have requests made to our public IP address on port 8080 / 443 be redirected to port 80 /443 on the container. Also, instead of serving content from the container itself, we will serve a simple web page from /home/user/website.

We do this by mapping /home/user/website/ on the /usr/local/apache2/htdocs/ on the container. Note that you will need to use sudo or log in as root to proceed, and do not omit the forward slashes at the end of each directory.

create your own container : 
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
Now let’s create a simple web page named index.html inside /home/user/website directory.
```bash
vi /home/user/website/index.html
```


Add the following sample HTML content to file.

```bash
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hello Apache </title>
</head>
<body>
    <h1>Hello from Apache</h1>   
</body>
</html>
```

Next, point your browser to rfinland.site:8080 (or use your host’s public IP address with binded 8080 port). You should be presented with the page we created previously.
also you can use this https (port 443)

atleast update your ca-certificates with these lines: 
```bash
cp /root/apache_config/certs/cert.pem /usr/local/share/ca-certificates/rfinland.crt
update-ca-certificates
 ```

