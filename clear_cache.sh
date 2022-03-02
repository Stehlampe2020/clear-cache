#!/bin/bash
version=1.2.3
printf "clear-cache, version $version\n"
datevar=$(date "+%F-%T-%Z")
cachepath="$HOME/.cache"
if [[ ! -f "$cachepath/cache_cleared_$datevar.log" ]]
then
    printf "Log file: $cachepath/cache_cleared_$datevar.log\n"
elif [ -f "$cachepath/cache_cleared_$datevar.log" ]
then
    printf "Log file $cachepath/cache_cleared_$datevar.log already exists, exiting...)\n"
    sleep 1
    exit
fi    
repeat yes | rm -vr $cachepath/.fr-* &>> "$cachepath/cache_cleared_$datevar.log"
repeat yes | rm -vr $cachepath/thumbnails/* &>> "$cachepath/cache_cleared_$datevar.log"
repeat yes | rm -vr $cachepath/at-spi* &>> "$cachepath/cache_cleared_$datevar.log"
if [ "$1" == "--rm-log" ]
then
    repeat yes | rm -vr $cachepath/cache_cleared_*
elif [ "$1" == "--rm-whole-cache" ]
then
    repeat yes | rm -vr $HOME/.cache/*
fi
