# Node Eonwe
echo "eonwe" > /etc/hostname
hostname -F /etc/hostname

# Node Earendil
echo "earendil" > /etc/hostname
hostname -F /etc/hostname

# Node Maglor
echo "maglor" > /etc/hostname
hostname -F /etc/hostname

# Node Cirdan
echo "cirdan" > /etc/hostname
hostname -F /etc/hostname

# Node Tirion
echo "tirion" > /etc/hostname
hostname -F /etc/hostname

# Node Valmar
echo "valmar" > /etc/hostname
hostname -F /etc/hostname

# Node Vingilot
echo "vingilot" > /etc/hostname
hostname -F /etc/hostname

# Node Lindon
echo "lindon" > /etc/hostname
hostname -F /etc/hostname

# Node Sirion
echo "sirion" > /etc/hostname
hostname -F /etc/hostname

# Node Elwing
echo "elwing" > /etc/hostname
hostname -F /etc/hostname

# Node Elrond
echo "elrond" > /etc/hostname
hostname -F /etc/hostname

# Node Tirion
nano /etc/bind/zones/db.k53.com #Lalu tambahkan
; A Records for all nodes
eonwe.k53.com.      IN      A       10.90.1.1
earendil.k53.com.   IN      A       10.90.1.2
elwing.k53.com.     IN      A       10.90.1.3
cirdan.k53.com.     IN      A       10.90.2.2
elrond.k53.com.     IN      A       10.90.2.3
maglor.k53.com.     IN      A       10.90.2.4
sirion.k53.com.     IN      A       10.90.3.2
lindon.k53.com.     IN      A       10.90.3.5
vingilot.k53.com.   IN      A       10.90.3.6

named-checkzone k53.com /etc/bind/zones/db.k53.com
service named restart

# Node lain
ping sirion.k53.com
ping earendil.k53.com