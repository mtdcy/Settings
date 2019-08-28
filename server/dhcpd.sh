#!/bin/sh

INTERFACE="enp5s0"

apt install isc-dhcp-server 

cat > /etc/dhcp/dhcpd.conf <<- EOF

default-lease-time 600;
max-lease-time 7200;

subnet 10.10.20.0 netmask 255.255.255.0 {
    interface $INTERFACE;
    range 10.10.20.1 10.10.20.99;
    option routers 10.10.20.1;
    option subnet-mask 255.255.255.0;
    option broadcast-address 10.10.20.255;
    option domain-name-servers 10.10.20.1;
}

EOF

cat > /etc/default/isc-dhcp-server <<- EOF
INTERFACES="$INTERFACE"
EOF

systemctl enable isc-dhcp-server
systemctl restart isc-dhcp-server

