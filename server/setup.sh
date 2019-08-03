#!/bin/sh 

SOURCE=`pwd`/`dirname $0`

apt install git
apt install traceroute 

$SHELL -x $SOURCE/iptables.sh 
$SHELL -x $SOURCE/n2n.sh 
$SHELL -x $SOURCE/proxy.sh 

