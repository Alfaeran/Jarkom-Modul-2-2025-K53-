# Node Sirion
cat > /etc/nginx/sites-available/www.k53.com << 'EOF'

server {
    listen 80;
    server_name 10.90.3.2 sirion.k53.com;
    
    return 301 http://www.k53.com$request_uri;
}

# Server utama dengan hostname kanonik
server {
    listen 80;
    server_name www.k53.com;
    
    location /admin/ {
        auth_basic "Restricted Access - Admin Area";
        auth_basic_user_file /etc/nginx/.htpasswd;
        
        alias /var/www/sirion/admin/;
        index index.html;
    }
    
    location = /admin {
        return 301 /admin/;
    }
    
    location /static/ {
        proxy_pass http://lindon.k53.com/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    location /static {
        proxy_pass http://lindon.k53.com/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    location /app/ {
        proxy_pass http://vingilot.k53.com/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    location /app {
        proxy_pass http://vingilot.k53.com/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    location / {
        root /var/www/sirion;
        index index.html;
        try_files $uri $uri/ =404;
    }
}
EOF

# Test
nginx -t
service nginx reload

# Install lynx for testing
apt-get install -y lynx

echo "Testing redirect from IP address..."
lynx -dump -head http://10.90.3.2/ | grep -i "location\|302\|301"

echo "Testing redirect from sirion.k53.com..."
lynx -dump -head http://sirion.k53.com/ | grep -i "location\|302\|301"

echo "Testing canonical domain www.k53.com..."
lynx -dump http://www.k53.com/ | head -20

echo "Testing static via canonical domain..."
lynx -dump http://www.k53.com/static | head -20

echo "Testing app via canonical domain..."
lynx -dump http://www.k53.com/app | head -20