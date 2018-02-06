#!/bin/bash 

cd $1
SRC=`pwd`
cd -
cd $2
DEST=`pwd`
cd -

cd $SRC; 
find . -type f |
while read line; do 
	echo $line 
	dir=`dirname $line`
	mkdir -p $DEST/$dir
	cp -rf $line $DEST/$dir
done
cd -
