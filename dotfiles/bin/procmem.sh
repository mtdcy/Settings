#!/bin/bash 



while true; do 

    pid=`adb shell ps | grep $1 | awk '{print $2}'`

    adb shell procmem $pid | tail -1 

    sleep 1
done
