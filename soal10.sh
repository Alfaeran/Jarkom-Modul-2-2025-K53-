apt-get update
apt-get install -y nginx php8.4-fpm

#Vingilot
cat > /etc/nginx/sites-available/app.k53.com << 'EOF'
server {
    listen 80;
    server_name app.k53.com vingilot.k53.com;
    
    root /var/www/app;
    index index.php;
    
    location / {
        try_files $uri $uri/ @rewrite;
    }
    
    location @rewrite {
        rewrite ^/(.+)$ /$1.php last;
    }
    
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
    
    location ~ /\.ht {
        deny all;
    }
}
EOF

ln -sf /etc/nginx/sites-available/app.k53.com /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

mkdir -p /var/www/app

cat > /var/www/app/index.php << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Vingilot - Dynamic Application</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            background: linear-gradient(to bottom right, #0f2027, #203a43, #2c5364);
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
            background: linear-gradient(135deg, #00d4ff, #00ffc3);
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
            background: linear-gradient(135deg, rgba(0, 212, 255, 0.1), rgba(0, 255, 195, 0.1));
            padding: 30px;
            border-radius: 15px;
            margin: 30px 0;
            border-left: 4px solid #00ffc3;
            box-shadow: 0 4px 15px rgba(0, 255, 195, 0.2);
        }
        .info h2 {
            color: #00ffc3;
            font-size: 1.8em;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .info p {
            margin: 12px 0;
            font-size: 1.1em;
            line-height: 1.6;
        }
        .info strong {
            color: #00d4ff;
            font-weight: 600;
        }
        a { 
            display: inline-block;
            color: #00ffc3;
            text-decoration: none;
            font-size: 1.1em;
            font-weight: 600;
            padding: 12px 25px;
            border: 2px solid #00ffc3;
            border-radius: 8px;
            transition: all 0.3s ease;
            margin-top: 20px;
        }
        a:hover {
            background: #00ffc3;
            color: #0f2027;
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(0, 255, 195, 0.4);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Vingilot</h1>
        <p class="subtitle">The ship that sails through dynamic waters</p>
        
        <div class="info">
            <h2>Server Information</h2>
            <p><strong>Server Time:</strong> <?php echo date('Y-m-d H:i:s'); ?></p>
            <p><strong>Client IP:</strong> <?php echo $_SERVER['REMOTE_ADDR']; ?></p>
            <p><strong>User Agent:</strong> <?php echo $_SERVER['HTTP_USER_AGENT']; ?></p>
        </div>
        
        <a href="/about">Learn more about Vingilot →</a>
    </div>
</body>
</html>
EOF

cat > /var/www/app/about.php << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>About Vingilot</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            background: linear-gradient(to bottom right, #1a1a2e, #16213e, #0f3460);
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
            margin-bottom: 30px;
            background: linear-gradient(135deg, #ff6b6b, #feca57);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 700;
            letter-spacing: 2px;
        }
        .content { 
            background: linear-gradient(135deg, rgba(255, 107, 107, 0.1), rgba(254, 202, 87, 0.1));
            padding: 35px;
            border-radius: 15px;
            margin: 30px 0;
            border-left: 4px solid #feca57;
            box-shadow: 0 4px 15px rgba(254, 202, 87, 0.2);
        }
        .content h2 {
            color: #feca57;
            font-size: 2em;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .content h3 {
            color: #ff6b6b;
            font-size: 1.5em;
            margin-top: 30px;
            margin-bottom: 15px;
            font-weight: 600;
        }
        .content p {
            margin: 15px 0;
            font-size: 1.1em;
            line-height: 1.8;
        }
        .content strong {
            color: #ff6b6b;
            font-weight: 600;
        }
        a { 
            display: inline-block;
            color: #feca57;
            text-decoration: none;
            font-size: 1.1em;
            font-weight: 600;
            padding: 12px 25px;
            border: 2px solid #feca57;
            border-radius: 8px;
            transition: all 0.3s ease;
            margin-top: 20px;
        }
        a:hover {
            background: #feca57;
            color: #1a1a2e;
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(254, 202, 87, 0.4);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>About Vingilot</h1>
        
        <div class="content">
            <h2>The Star Ship</h2>
            <p>Vingilot adalah kapal yang dipandu oleh Earendil, membawa Silmaril melintasi langit sebagai bintang paling terang.</p>
            
            <h3>Technical Details</h3>
            <p><strong>Powered by:</strong> PHP <?php echo phpversion(); ?></p>
            <p><strong>Server:</strong> Nginx</p>
            <p><strong>Current Path:</strong> <?php echo $_SERVER['REQUEST_URI']; ?></p>
            <p><strong>Access Time:</strong> <?php echo date('Y-m-d H:i:s'); ?></p>
        </div>
        
        <a href="/">← Back to Home</a>
    </div>
</body>
</html>
EOF

chown -R www-data:www-data /var/www/app
nginx -t
service nginx restart
service php8.4-fpm restart

# Test
curl http://app.k53.com
curl http://app.k53.com/about