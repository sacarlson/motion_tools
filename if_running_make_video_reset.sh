#!/bin/bash 
#
#this is setup for motion to convert jpg sequence to video
# run motion from within this directory to have it save images here
# then run this script at any time to convert what it has captured to video mp4 format
# Copyright (c) 2014  Scott Carlson  sacarlson@ipipi.com 

# this just cd's to the real path that the script is located so that it can be run from a symbolic link on my desktop or from cron
SELF_PATH=$(cd -P -- "$(dirname -- "$0")" && pwd -P) && SELF_PATH=$SELF_PATH/$(basename -- "$0") ; REALP=$(realpath $SELF_PATH) ; cd $(dirname -- "$REALP")

if [ -d "./images" ]; then
  cd ./images || exit ;
else
  mkdir ./images || exit ;
  cd ./images || exit ;
fi

if [ -d "./links" ]; then
  echo "links dir already exists will do nothing \n"
else
  mkdir ./links || exit ;
fi
rm -f ./links/*.*

if [ "$(pidof motion)" ] 
 then 
   echo "motion is already running so will make video" 
   NOW=$(date +"%y_%m_%d_%H:%M")
   FILE=$NOW.mp4
   echo $FILE
   
 x=1; for i in $(ls -r -t *jpg); do counter=$(printf %04d $x); ln -s ../"$i" ./links/"$counter".jpg; x=$(($x+1)); done

   cd ./links || exit ;
   avconv -r 30 -i %04d.jpg -vcodec mpeg4 $FILE
   #rcp ./$FILE sacarlson@192.168.2.250:/home/sacarlson/GoogleDrive/motion/$FILE
   # delete any mp4 files that are older than 30 days old
   find . -name '*.mp4' -mtime +30 -exec rm {} \;
   rm *.jpg
   cd ..
   rm *.jpg
 else 
   echo "motion NOT running nothing will be done"
fi

