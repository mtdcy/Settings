#!/bin/bash 

# $0 <old> <new> <path> 

_old=$1
_new=$2
_target=$3

grep.sh -w $_old $_target -l | xargs sed -i "s%\<${_old}\>%${_new}%g"
