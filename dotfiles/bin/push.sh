#!/bin/bash

function push_files() {
for file in $@; do
    target_path=`echo $file | cut -d/ -f5-`
    echo "push $target_path"
    adb push $file $target_path 
    adb shell chmod 777 $target_path
done
}

adb wait-for-devices
push_files $@
if [ $? -ne 0 ]; then 
    adb vivoroot 
    adb wait-for-devices
    adb remount 
    adb wait-for-devices

    push_files $@
fi

adb shell sync
