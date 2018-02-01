#!/bin/bash

. `which cbox.sh`

gentags=0

while getopts "i:g" opt; do 
    case $opt in 
        i) 
            info "add path $OPTARG" 
            cat files > /tmp/files
            find $OPTARG -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' -o -name '*.java' \) | tee -a /tmp/files
            sort /tmp/files | uniq > files
            ;;
        g) 
            gentags=1
            ;;
        *)
            error "Unkown option $opt"
            ;;
    esac
done

if [ $gentags -ne 0 ]; then 
    info "gen tags"
    cscope -bkq -i files 
    ctags -R --fields=+ailS --c-kinds=+p --c++-kinds=+p --sort=no --extra=+q -L files
fi
