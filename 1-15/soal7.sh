# Node Tirion
nano /etc/bind/zones/db.k53.com #Lalu tambahkan
www.k53.com.        IN      CNAME   sirion.k53.com.
static.k53.com.     IN      CNAME   lindon.k53.com.
app.k53.com.        IN      CNAME   vingilot.k53.com.

named-checzone k53.com /etc/bind/zones/db.k53.com
service named restart

# Coba di Node yang beda
dig www.k53.com
dig static.k53.com
dig app.k53.com