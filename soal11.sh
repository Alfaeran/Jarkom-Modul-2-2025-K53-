apt-get update
apt-get install -y nginx

# Sirion 
cat > /etc/nginx/sites-available/www.k53.com << 'EOF'
server {
    listen 80;
    server_name www.k53.com sirion.k53.com;
    
    # Path-based routing ke Lindon (static)
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
    
    # Path-based routing ke Vingilot (app)
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
    
    # Default location untuk root
    location / {
        root /var/www/sirion;
        index index.html;
        try_files $uri $uri/ =404;
    }
}
EOF

ln -sf /etc/nginx/sites-available/www.k53.com /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

mkdir -p /var/www/sirion
cat > /var/www/sirion/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Sirion - Gateway of Beleriand</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            background: linear-gradient(to bottom right, #2d1b4e, #1e3a5f, #0a4f6e);
            color: #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            max-width: 900px;
            width: 100%;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 50px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }
        h1 { 
            font-size: 3em;
            margin-bottom: 15px;
            background: linear-gradient(135deg, #a78bfa, #06b6d4);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 700;
            letter-spacing: 2px;
        }
        .subtitle {
            font-size: 1.2em;
            color: #b0b0b0;
            margin-bottom: 40px;
            font-style: italic;
        }
        .info { 
            background: linear-gradient(135deg, rgba(167, 139, 250, 0.1), rgba(6, 182, 212, 0.1));
            padding: 30px;
            border-radius: 15px;
            margin: 25px 0;
            border-left: 4px solid #06b6d4;
            box-shadow: 0 4px 15px rgba(6, 182, 212, 0.2);
        }
        .info h2 {
            color: #06b6d4;
            font-size: 1.8em;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .info h3 {
            color: #a78bfa;
            font-size: 1.5em;
            margin-bottom: 15px;
            font-weight: 600;
        }
        .info p {
            font-size: 1.1em;
            line-height: 1.6;
            margin-top: 10px;
        }
        a { 
            color: #a78bfa;
            text-decoration: none;
            display: block;
            margin: 15px 0;
            padding: 15px 20px;
            background: rgba(167, 139, 250, 0.1);
            border-radius: 10px;
            border: 2px solid transparent;
            font-size: 1.1em;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        a:hover {
            background: rgba(167, 139, 250, 0.2);
            border-color: #a78bfa;
            transform: translateX(10px);
            box-shadow: 0 5px 20px rgba(167, 139, 250, 0.3);
        }
        .service-links a {
            display: flex;
            align-items: center;
            gap: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Sirion</h1>
        <p class="subtitle">The Gateway and Reverse Proxy of Beleriand</p>
        
        <div class="info">
            <h2>Available Services</h2>
            <div class="service-links">
                <a href="/static">→ Static Archives (Lindon)</a>
                <a href="/app">→ Dynamic Application (Vingilot)</a>
            </div>
        </div>
        
        <div class="info">
            <h3>About Sirion</h3>
            <p>Sirion berdiri sebagai reverse proxy yang mengarahkan trafik ke berbagai layanan di Beleriand.</p>
        </div>
    </div>
</body>
</html>
EOF

chown -R www-data:www-data /var/www/sirion

nginx -t
service nginx restart
service nginx status

# Install lynx for testing
apt-get install -y lynx

# Test
echo "Testing Sirion homepage..."
lynx -dump http://www.k53.com

echo "Testing Sirion via sirion.k53.com..."
lynx -dump http://sirion.k53.com

echo "Testing static route /static..."
lynx -dump http://www.k53.com/static

echo "Testing static annals directory..."
lynx -dump http://www.k53.com/static/annals/

echo "Testing app route /app..."
lynx -dump http://www.k53.com/app

echo "Testing app about page..."
lynx -dump http://www.k53.com/app/about