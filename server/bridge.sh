#!/bin/sh

SOURCE=`pwd`/`dirname $0`

source $SOURCE/cbox.sh

apt install bridge-utils

INTERFACE1=eno1
INTERFACE2=enp5s0
IP=`which ip`
BRCTL=`which brctl`
BR0="bridge0"

cat > /etc/network/if-up.d/$BR0 <<- EOF
#!/bin/sh

[ "\$IFACE" != "lo" ] || exit 0 
[ "\$IFACE" != "$INTERFACE1" ] || exit 0

$IP addr flush dev $INTERFACE2 
$BRCTL addbr $BR0
$BRCTL addif $BR0 $INTERFACE1 $INTERFACE2
$IP link set dev $BR0 up

EOF

chmod a+x /etc/network/if-up.d/$BR0
systemctl restart networking.service
