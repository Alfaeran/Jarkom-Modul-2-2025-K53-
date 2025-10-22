# Node Tirion
nano /etc/bind/named.conf.local # Ganti dengan
zone "k53.com" {
    type master;
    file "/etc/bind/zones/db.k53.com";
    allow-transfer { 10.90.3.4; };
    also-notify { 10.90.3.4; };
};

nano /etc/bind/zones/db.10.90.3 # Masukkin
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

; PTR Records
2       IN      PTR     sirion.k53.com.
3       IN      PTR     ns1.k53.com.
4       IN      PTR     ns2.k53.com.
5       IN      PTR     lindon.k53.com.
6       IN      PTR     vingilot.k53.com.

named-checkzone 3.90.10.in-addr.arpa /etc/bind/zones/db.10.90.3
service named restart

# Node Valmar 
nano /etc/bind/named.conf.local # Sesuaiin dengan
zone "k53.com" {
    type slave;
    file "/etc/bind/zones/db.k53.com";
    masters { 10.90.3.3; };
};

zone "3.90.10.in-addr.arpa" {
    type slave;
    file "db.10.90.3";
    masters { 10.90.3.3; };
};

service named restart

# Node lain
dig -x 10.90.3.2
dig -x 10.90.3.5
dig -x 10.90.3.6