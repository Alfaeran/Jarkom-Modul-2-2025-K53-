
apt-get update
apt-get install -y apache2-utils

htpasswd -c -b /etc/nginx/.htpasswd admin admin123

chmod 644 /etc/nginx/.htpasswd
chown www-data:www-data /etc/nginx/.htpasswd

# Node Sirion
cat > /etc/nginx/sites-available/www.k53.com << 'EOF'
server {
    listen 80;
    server_name www.k53.com sirion.k53.com;
    
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

mkdir -p /var/www/sirion/admin

cat > /var/www/sirion/admin/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel - Sirion</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            background: linear-gradient(to bottom right, #1a1a1a, #2d2d2d, #1f1f1f);
            color: #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            max-width: 950px;
            width: 100%;
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            border: 1px solid rgba(255, 215, 0, 0.2);
            padding: 50px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
        }
        h1 { 
            font-size: 3em;
            margin-bottom: 15px;
            background: linear-gradient(135deg, #ffd700, #ffed4e);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 700;
            letter-spacing: 2px;
        }
        .subtitle {
            font-size: 1.2em;
            color: #b0b0b0;
            margin-bottom: 35px;
            font-style: italic;
        }
        .panel { 
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.05), rgba(255, 237, 78, 0.05));
            padding: 25px;
            border-radius: 15px;
            margin: 20px 0;
            border-left: 4px solid #ffd700;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.1);
        }
        .panel h2 {
            color: #ffd700;
            font-size: 1.6em;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .panel h3 {
            color: #ffed4e;
            font-size: 1.4em;
            margin-bottom: 15px;
            font-weight: 600;
        }
        .panel p {
            margin: 12px 0;
            font-size: 1.05em;
            line-height: 1.6;
        }
        .warning {
            background: linear-gradient(135deg, rgba(255, 50, 50, 0.15), rgba(220, 20, 60, 0.15));
            padding: 20px;
            border-radius: 15px;
            margin: 25px 0;
            border-left: 4px solid #ff3333;
            box-shadow: 0 4px 15px rgba(255, 50, 50, 0.2);
        }
        .warning h3 {
            color: #ff6b6b;
            font-size: 1.4em;
            margin-bottom: 12px;
            font-weight: 600;
        }
        .warning p {
            color: #ffcccc;
            font-size: 1.05em;
            line-height: 1.6;
        }
        a { 
            color: #ffd700;
            text-decoration: none;
            font-weight: 600;
            padding: 8px 15px;
            background: rgba(255, 215, 0, 0.1);
            border-radius: 8px;
            display: inline-block;
            margin: 8px 10px 8px 0;
            transition: all 0.3s ease;
        }
        a:hover {
            background: rgba(255, 215, 0, 0.2);
            transform: translateX(5px);
            box-shadow: 0 3px 15px rgba(255, 215, 0, 0.3);
        }
        .status { 
            color: #00ff88;
            font-size: 1.2em;
            text-shadow: 0 0 10px rgba(0, 255, 136, 0.5);
        }
        strong {
            color: #00ff88;
        }
        .admin-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }
        .admin-actions p {
            background: rgba(255, 215, 0, 0.08);
            padding: 15px;
            border-radius: 10px;
            border: 1px solid rgba(255, 215, 0, 0.2);
            transition: all 0.3s ease;
        }
        .admin-actions p:hover {
            background: rgba(255, 215, 0, 0.15);
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.2);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔐 Admin Panel</h1>
        <p class="subtitle">Welcome to Sirion's restricted area</p>
        
        <div class="warning">
            <h3>⚠️ Restricted Access</h3>
            <p>This area is protected by Basic Authentication. Only authorized personnel are allowed.</p>
        </div>
        
        <div class="panel">
            <h2>System Status</h2>
            <p><span class="status">●</span> Sirion Gateway: <strong>Online</strong></p>
            <p><span class="status">●</span> Lindon Backend: <strong>Online</strong></p>
            <p><span class="status">●</span> Vingilot Backend: <strong>Online</strong></p>
        </div>
        
        <div class="panel">
            <h2>Quick Links</h2>
            <a href="/">← Back to Home</a>
            <a href="/static">📁 View Static Content</a>
            <a href="/app">⚡ View Dynamic App</a>
        </div>
        
        <div class="panel">
            <h3>Admin Actions</h3>
            <div class="admin-actions">
                <p>⚙️ Server Configuration</p>
                <p>📊 Monitor Traffic</p>
                <p>📋 View Logs</p>
                <p>👥 Manage Users</p>
            </div>
        </div>
    </div>
</body>
</html>
EOF

chown -R www-data:www-data /var/www/sirion

nginx -t
service nginx reload

# Install lynx for testing
apt-get install -y lynx

# Test
echo "Testing Admin panel without credentials (should be denied)..."
lynx -dump http://www.k53.com/admin/ 2>&1 || echo "Access denied as expected"

echo "Testing with wrong credentials..."
lynx -auth=admin:wrongpass -dump http://www.k53.com/admin/ 2>&1 || echo "Wrong credentials rejected"

echo "Testing with correct credentials (admin:admin123)..."
lynx -auth=admin:admin123 -dump http://www.k53.com/admin/

echo "Testing homepage..."
lynx -dump http://www.k53.com/

echo "Testing static content..."
lynx -dump http://www.k53.com/static

echo "Testing app content..."
lynx -dump http://www.k53.com/app