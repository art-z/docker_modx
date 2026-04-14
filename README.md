db connect
```
HOST modx-db
MYSQL_DATABASE=modx
MYSQL_USER=modx
MYSQL_PASSWORD=super_strong_pass_change_me
```
nginx config  
 
```
server {
    listen 443 ssl;
    server_name SITE_NAME;

    root /var/www/SITE_NAME/app/public;
    index index.php index.html;

    client_max_body_size 100M;
    client_body_timeout 300s;
    fastcgi_read_timeout 300s;
    send_timeout 300s;

    ssl_certificate /etc/letsencrypt/live/SITE_NAME/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/SITE_NAME/privkey.pem;

    access_log /var/log/nginx/LOGFILE_NAME.access.log;
    error_log /var/log/nginx/LOGFILE_NAME.error.log;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass modx-php:9000;
        fastcgi_index index.php;

        fastcgi_param SCRIPT_FILENAME /app/public$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT /app/public;
        fastcgi_read_timeout 300;
    }

    location ~* \.(jpg|jpeg|png|gif|webp|svg|ico|css|js|woff|woff2|ttf)$ {
        expires 30d;
        access_log off;
        add_header Cache-Control "public, immutable";
        try_files $uri =404;
    }

    location ~ /\. {
        deny all;
    }
}

server {
    listen 80;
    server_name SITE_NAME;
    return 301 https://SITE_NAME$request_uri;
}

```