#!/bin/sh 

SOURCE=`pwd`/`dirname $0`

apt install vim cscope ctags
apt install git wget
apt install traceroute 
# 
apt install build-essential cmake
# force create *.deb
apt install debhelper fakeroot dpkg-sig
#
apt install landscape-common

$SHELL -x $SOURCE/iptables.sh 
$SHELL -x $SOURCE/n2n.sh 
$SHELL -x $SOURCE/proxy.sh 

