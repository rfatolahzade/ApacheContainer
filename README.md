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

