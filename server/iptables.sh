#!/bin/sh 

# defaults
sed -i '/^#net.ipv4.ip_forward/s/^#//' /etc/sysctl.conf

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

# defaults
# https://help.ubuntu.com/community/IptablesHowTo#Allowing_Established_Sessions
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -t nat -A POSTROUTING -j MASQUERADE

# enable protocols
iptables -A INPUT -p tcp --dport 22 -j ACCEPT   # ssh 
iptables -A INPUT -p tcp --dport 53 -j ACCEPT   # dns
iptables -A INPUT -p tcp --dport 80 -j ACCEPT   # http
iptables -A INPUT -p tcp --dport 443 -j ACCEPT  # https

# INPUT 
# some daemon may listen on loopback like systemd-resolved
iptables -A INPUT -i lo -j ACCEPT               # accept loopback traffic
iptables -A INPUT -s 10.10.10.0/24 -j ACCEPT    # accept local net traffic
iptables -A INPUT -s 10.0.0.0/24 -j ACCEPT      # accept n2n net traffic

# FORWARD 
iptables -A FORWARD -s 10.10.10.0/24 -j ACCEPT  # forward local traffic
iptables -A FORWARD -s 10.0.0.0/24 -j ACCEPT    # forward n2n traffic
iptables -A FORWARD -d 10.0.0.0/24 -j ACCEPT    # forward n2n traffic

# set default policy 
iptables -P INPUT DROP 
iptables -P FORWARD DROP

# save iptable rules
iptables-save > /etc/iptables.rules

cat > /etc/network/if-up.d/iptables <<- EOF
#!/bin/bash
iptables-restore < /etc/iptables.rules
exit 0
EOF
chmod a+x /etc/network/if-up.d/iptables 

sysctl -p

exit 0
