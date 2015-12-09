#!/bin/bash


PID=`adb shell ps | grep $1 | awk '{print $2}'`

perl `dirname $0`/pidmem.pl -i 1 $PID
