#!/bin/bash 

DEFAULT_FILE="/work/Log/`date +%Y%m%d%H%M%S`.txt"
LNK="/work/Log/current.txt"


function usage() {
    echo "logcat.sh <options>"
    echo "  o - output file name"
    echo "  p - process name"
    echo "  t - match tags. e.g Vivo|Extractor "
}

LOG_FILE=$DEFAULT_FILE;
TARGET_PID=""
MATCH_TAGS=""
while getopts "o:p:t:" opt; do 
    case $opt in
        o)
            LOG_FILE=$OPTARG;
            ;;
        p)
            adb wait-for-device
            TARGET_PID=`adb shell ps | grep $OPTARG | awk '{print $2}'`;
            ;;
        t)
            MATCH_TAGS=(`echo $OPTARG | sed -s 's/|/\ /g'`)
            ;;
        *)
            echo "unkown option $opt";
            usage;
            exit 1;
    esac
done

touch $LOG_FILE;
ln -svf ${LOG_FILE} ${LNK};

adb wait-for-device
echo "TARGET_PID:$TARGET_PID"
echo "MATCH_TAGS:${MATCH_TAGS[@]}"
echo "start capturing logs..."

function my_logcat() {
    filter_options=""
    if [ ! -z "${MATCH_TAGS}" ]; then 
        for ((i=0; i<${#MATCH_TAGS[@]}; i++)); do
            filter_options="$filter_options -s ${MATCH_TAGS[$i]}";
        done
    fi
    echo $filter_options;
    adb logcat -v threadtime $filter_options
}


if [ "$TARGET_PID"x != ""x ]; then 
    my_logcat | grep --line-buffered -wE "$TARGET_PID|DEBUG|FATAL|AEE"
else
    my_logcat 
fi

