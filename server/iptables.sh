#!/bin/sh 

# defaults
sed -i '/^#net.ipv4.ip_forward/s/^#//' /etc/sysctl.conf
sysctl -p

# avoid losing connections
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT 

# flush everything
iptables -F
iptables -F -t nat
iptables -F -t mangle
iptables -X
iptables -X -t nat
iptables -X -t mangle

################################################################################
# INPUT
# https://help.ubuntu.com/community/IptablesHowTo#Allowing_Established_Sessions
#iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# enable protocols
iptables -A INPUT -p tcp --dport 22 -j ACCEPT   # ssh 
iptables -A INPUT -p tcp --dport 53 -j ACCEPT   # dns
iptables -A INPUT -p tcp --dport 80 -j ACCEPT   # http
iptables -A INPUT -p tcp --dport 443 -j ACCEPT  # https

# some daemon may listen on loopback like systemd-resolved
iptables -A INPUT -i lo -j ACCEPT               # accept loopback traffic
iptables -A INPUT -s 10.10.10.0/24 -j ACCEPT    # accept local net traffic
iptables -A INPUT -s 10.0.0.0/24 -j ACCEPT      # accept n2n net traffic

# INPUT/DROP 
iptables -A INPUT -j LOG --log-prefix "iptables[INPUT/DROP]: "
iptables -A INPUT -j DROP 

################################################################################
# FORWARD 
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 10.10.10.0/24 -j ACCEPT  # forward local traffic
iptables -A FORWARD -s 10.0.0.0/24 -j ACCEPT    # forward n2n traffic
iptables -A FORWARD -d 10.0.0.0/24 -j ACCEPT    # forward n2n traffic

# FORWARD/DROP
iptables -A FORWARD -j LOG --log-prefix "iptables[FORWARD/DROP]: "
iptables -A FORWARD -j DROP

################################################################################
# NAT
# some daemon may listen on loopback like systemd-resolved, so exclude loopback interface
iptables -t nat -A POSTROUTING ! -o lo -j MASQUERADE

################################################################################
# save iptable rules
iptables-save > /etc/iptables.rules

cat > /etc/network/if-up.d/iptables <<- EOF
#!/bin/bash
iptables-restore < /etc/iptables.rules
exit 0
EOF
chmod a+x /etc/network/if-up.d/iptables 

exit 0
