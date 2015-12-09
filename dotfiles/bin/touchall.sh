#!/bin/bash 


find $1 ! -path '*/.*' -type f | xargs touch 
