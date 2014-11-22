#!/bin/bash 
#
#this setup for motion to convert jpg sequence to video
# run motion from within this directory to have it save images here
# then run this script at any time to convert what it has captured to video mp4 format
#  this one is modified to only make a video of images captured over the last 24 hours (note -mtime -1)
# Copyright (c) 2014  Scott Carlson  sacarlson@ipipi.com 

# this just cd's to the real path that the script is located so that it can be run from a symbolic link on my desktop
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

NOW=$(date +"%y_%m_%d_%H:%M")
FILE=$NOW.mp4
echo $FILE

 x=1; for i in $(find . -maxdepth 1 -mtime -1 -iname "*.JPG" -printf "%T@ %Tc %p\n" | sort -n | grep -oE '[^ ]+$'); do counter=$(printf %04d $x); ln -s ../"$i" ./links/"$counter".jpg; x=$(($x+1)); done
echo "combine link complete \n"

cd ./links || exit ;
avconv -r 30 -i %04d.jpg -vcodec mpeg4 $FILE
#avconv -r 30 -i %04d.jpg -s hd1080 -vcodec mpeg4 $FILE
cp $FILE ../../today_$FILE
echo "video conversion completed \n"
vlc ./$FILE

