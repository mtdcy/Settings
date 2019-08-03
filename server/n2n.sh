#!/bin/sh 

test -d n2n || git clone https://github.com/ntop/n2n.git

cd n2n && git checkout 2.4-stable

cd packages/ubuntu && ./configure && make 

dpkg -i ../n2n*.deb

systemctl enable edge 
systemctl disable edge@

if [ "$1" = "supernode" ]; then
    systemctl enable supernode 
    sed -i 's/network.target/network-online.target/' /etc/systemd/system/supernode.service

    # supernode
    cat > /etc/n2n/supernode.conf <<- EOF
--local-port=8087
EOF

    systemctl stop supernode 
    systemctl start supernode 

    # edge node as network gate
    cat > /etc/n2n/edge.conf <<- EOF
-c=chen
-k=chen1234
-a=10.0.0.1
-l=localhost:8087
-r
EOF

else
    # edge node
    cat > /etc/n2n/edge.conf <<- EOF
-c=chen
-k=chen1234
-a=10.0.0.100
-l=mtdcy.com:8087
-r
EOF
fi

sed -i 's/network.target/network-online.target/' /etc/systemd/system/edge.service

systemctl stop edge
systemctl start edge

