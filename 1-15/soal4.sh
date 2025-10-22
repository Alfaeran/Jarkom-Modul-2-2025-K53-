# Node Tirion
apt-get update && apt-get install -y bind9 dnsutils

nano /etc/bind/named.conf.options #Lalu ganti semua dengan
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-transfer { 10.90.3.4; };
    notify yes;
    listen-on { any; };

    dnssec-validation auto;
    listen-on-v6 { any; };
};


nano /etc/bind/named.conf.local #lalu ganti semua dengan
zone "k53.com" {
    type master;
    file "/etc/bind/zones/db.k53.com";
    allow-transfer { 10.90.3.4; };
    also-notify { 10.90.3.4; };
    notify yes;
};


mkdir -p /etc/bind/zones
nano /etc/bind/zones/db.k53.com #Lalu ganti semua dengan
$TTL    604800
@       IN      SOA     ns1.k53.com. admin.k53.com. (
                              2025101101         ; Serial
                              604800         ; Refresh
                              86400         ; Retry
                              2419200         ; Expire
                              604800 )       ; Negative Cache TTL
;
; Name Servers
@       IN      NS      ns1.k53.com.
@       IN      NS      ns2.k53.com.

; A Records for Name Servers
ns1.k53.com.        IN      A       10.90.3.3
ns2.k53.com.        IN      A       10.90.3.4

; A Record for apex (front door)
@                   IN      A       10.90.3.2


chown -R bind:bind /etc/bind/zones
named-checkconf
named-checkzone k53.com /etc/bind/zones/db.k53.com
service named restart


# Node Valmar
apt-get update && apt-get install -y bind9 dnsutils

nano /etc/bind/named.conf.options #Lalu ganti semua dengan
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    dnssec-validation auto;
    listen-on-v6 { any; };
};

nano /etc/bind/named.conf.local #Lalu ganti semua dengan
zone "k53.com" {
    type slave;
    file "/etc/bind/zones/db.k53.com";
    masters { 10.90.3.3; };
};

named-checkconf
service named restart

echo "nameserver 10.90.3.3" > /etc/resolv.conf
echo "nameserver 10.90.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf

# di semua node selain eonwe dan tirion
cat > /etc/resolv.conf << 'EOF'
nameserver 10.90.3.3

nameserver 192.168.122.1
EOF

# Tes ping k53.com
ping k53.com
# Jika berhasil, CTRL + C untuk kembali