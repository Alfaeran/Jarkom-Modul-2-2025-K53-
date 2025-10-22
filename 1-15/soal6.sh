# Node Tirion
dig @10.90.3.3 k53.com SOA

# Node Valmar
echo "nameserver 127.0.0.1" > /etc/resolv.conf
dig @10.90.3.3 k53.com SOA

mkdir -p /etc/bind/zones/
chown bind:bind /etc/bind/zones/

rndc retransfer k53.com
ls -l /etc/bind/zones/db.k53.com
cat /etc/bind/zones/db.k53.com

# pastiin lagi
dig @10.90.3.4 k53.com SOA