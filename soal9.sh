# Node Lindon
apt-get update && apt-get install -y nginx

nano > /etc/nginx/sites-available/static.k53.com # Masukkan
server {
    listen 80;
    server_name static.k25.com lindon.k25.com;
    
    root /var/www/static;
    index index.html;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    location /annals/ {
        alias /var/www/static/annals/;
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }
}

ln -sf /etc/nginx/sites-available/static.k53.com /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

mkdir -p /var/www/static/annals
echo "tes" > /var/www/static/tes.txt

nginx -t
service nginx restart

curl http://static.k53.com
curl http://lindon.k53.com/annals/