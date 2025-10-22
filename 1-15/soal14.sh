# Node Vingilot
cat > /etc/nginx/sites-available/app.k53.com << 'EOF'

# log format yang mencatat X-Real-IP
log_format real_ip '$remote_addr - $http_x_real_ip - $remote_user [$time_local] '
                   '"$request" $status $body_bytes_sent '
                   '"$http_referer" "$http_user_agent"';

server {
    listen 80;
    server_name app.k53.com vingilot.k53.com;
    
    # Set real IP dari header yang dikirim Sirion
    set_real_ip_from 10.90.3.2;  # IP Sirion
    real_ip_header X-Real-IP;
    real_ip_recursive on;
    
    # Log dengan format yang mencatat IP asli
    access_log /var/log/nginx/vingilot_access.log real_ip;
    error_log /var/log/nginx/vingilot_error.log;
    
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
        fastcgi_param REMOTE_ADDR $remote_addr;
        include fastcgi_params;
    }
    
    location ~ /\.ht {
        deny all;
    }
}
EOF

# Test
nginx -t
service nginx restart

cat > /var/www/app/checkip.php << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Check IP - Vingilot</title>
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
            font-size: 2.8em;
            margin-bottom: 35px;
            background: linear-gradient(135deg, #00d4ff, #00ffc3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 700;
            letter-spacing: 1px;
        }
        .info { 
            background: linear-gradient(135deg, rgba(0, 212, 255, 0.1), rgba(0, 255, 195, 0.1));
            padding: 30px;
            border-radius: 15px;
            margin: 25px 0;
            border-left: 4px solid #00ffc3;
            box-shadow: 0 4px 15px rgba(0, 255, 195, 0.2);
        }
        .info h2 {
            color: #00ffc3;
            font-size: 1.7em;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .info p {
            margin: 15px 0;
            font-size: 1.1em;
            line-height: 1.8;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 10px;
        }
        .info strong {
            color: #00d4ff;
            font-weight: 600;
            min-width: 200px;
        }
        .highlight { 
            color: #ffd700;
            font-weight: 700;
            background: rgba(255, 215, 0, 0.1);
            padding: 5px 12px;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            font-size: 1.05em;
            border: 1px solid rgba(255, 215, 0, 0.3);
        }
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 5px;
            font-size: 0.85em;
            font-weight: 600;
            margin-left: 10px;
        }
        .badge-primary {
            background: rgba(0, 212, 255, 0.2);
            color: #00d4ff;
            border: 1px solid rgba(0, 212, 255, 0.4);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌐 IP Address Check - Vingilot</h1>
        
        <div class="info">
            <h2>🔍 Client Information</h2>
            <p><strong>Your Real IP:</strong> <span class="highlight"><?php echo $_SERVER['REMOTE_ADDR']; ?></span> <span class="badge badge-primary">REMOTE_ADDR</span></p>
            <p><strong>X-Real-IP Header:</strong> <span class="highlight"><?php echo isset($_SERVER['HTTP_X_REAL_IP']) ? $_SERVER['HTTP_X_REAL_IP'] : 'Not set'; ?></span></p>
            <p><strong>X-Forwarded-For:</strong> <span class="highlight"><?php echo isset($_SERVER['HTTP_X_FORWARDED_FOR']) ? $_SERVER['HTTP_X_FORWARDED_FOR'] : 'Not set'; ?></span></p>
        </div>
        
        <div class="info">
            <h2>📋 Request Information</h2>
            <p><strong>Request Time:</strong> <?php echo date('Y-m-d H:i:s'); ?></p>
            <p><strong>Request URI:</strong> <span class="highlight"><?php echo $_SERVER['REQUEST_URI']; ?></span></p>
            <p><strong>User Agent:</strong> <?php echo $_SERVER['HTTP_USER_AGENT']; ?></p>
        </div>
    </div>
</body>
</html>
EOF

chown -R www-data:www-data /var/www/app

# Install lynx for testing
apt-get install -y lynx

# Test - Display real IP via web
echo "Testing checkip page via vingilot.k53.com..."
lynx -dump http://vingilot.k53.com/checkip

echo "Testing checkip page via www.k53.com/app/checkip..."
lynx -dump http://www.k53.com/app/checkip

# View access logs
echo "Checking Vingilot access logs (should show client IP, not proxy IP)..."
tail -20 /var/log/nginx/vingilot_access.log