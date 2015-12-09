#!/bin/bash 

while true; do 
    DATE=(`adb shell date`)

    STAT=(`adb shell cat /sys/block/mmcblk0/stat`)

    echo "${DATE[3]} | ${STAT[@]}" 

    sleep .1
done 
