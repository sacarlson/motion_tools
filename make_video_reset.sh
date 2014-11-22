#!/bin/bash 
# This will make a video from all motion data and then delete all the images after video is created
# note this still uses ffmpeg so won't work on ubuntu any more

# this just cd's to the real path that the script is located so that it can be run from a symbolic link on my desktop or from cron
SELF_PATH=$(cd -P -- "$(dirname -- "$0")" && pwd -P) && SELF_PATH=$SELF_PATH/$(basename -- "$0") ; REALP=$(realpath $SELF_PATH) ; cd $(dirname -- "$REALP")

NOW=$(date +"%y_%m_%d_%H:%M")
FILE=$NOW.mp4
echo $FILE
mkdir ./img
rm ./img/*.jpg
 x=1; for i in $(ls -r -t *jpg); do counter=$(printf %04d $x); ln -s ../"$i" ./img/"$counter".jpg; x=$(($x+1)); done
cd ./img
ffmpeg -r 30 -i %04d.jpg -vcodec mpeg4 $FILE
rm *.jpg
cd ..
rm *.jpg


