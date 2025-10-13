# atur konfigurasi eonwe
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 10.90.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.90.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 10.90.3.1
    netmask 255.255.255.0

# atur konfigurasi Earendil
auto eth0
iface eth0 inet static
    address 10.90.1.2
    netmask 255.255.255.0
    gateway 10.90.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# atur konfigurasi Elwing
auto eth0
iface eth0 inet static
    address 10.90.1.3
    netmask 255.255.255.0
    gateway 10.90.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# atur konfigurasi Cirdan
auto eth0
iface eth0 inet static
    address 10.90.2.2
    netmask 255.255.255.0
    gateway 10.90.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# atur konfigurasi Elrond
auto eth0
iface eth0 inet static
    address 10.90.2.3
    netmask 255.255.255.0
    gateway 10.90.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# atur konfigurasi Maglor
auto eth0
iface eth0 inet static
    address 10.90.2.4
    netmask 255.255.255.0
    gateway 10.90.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# atur konfigurasi Sirion
auto eth0
iface eth0 inet static
    address 10.90.3.2
    netmask 255.255.255.0
    gateway 10.90.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# atur konfigurasi Tirion
auto eth0
iface eth0 inet static
    address 10.90.3.3
    netmask 255.255.255.0
    gateway 10.90.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# atur konfigurasi Valmar
auto eth0
iface eth0 inet static
    address 10.90.3.4
    netmask 255.255.255.0
    gateway 10.90.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# atur konfigurasi Lindon
auto eth0
iface eth0 inet static
    address 10.90.3.5
    netmask 255.255.255.0
    gateway 10.90.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# atur konfigurasi Vingilot
auto eth0
iface eth0 inet static
    address 10.90.3.6
    netmask 255.255.255.0
    gateway 10.90.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf