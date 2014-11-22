#!/bin/bash
# make_vid_events.sh 
# make video of motion files that were modified a minimum of $lag time since last modified file
# this will detect image motion detected when no motion has been seen for some time
# lag is in secounds
# in this case 30 minutes or 1800 seconds I found to be a good number
# in this version we create a video of each event with the time of each event clip depending on the event_image_count
# we now capture at 3 images per secound so 100 images will be about 33 secounds for each event.
# video is set to playback at 30fps so video plays back at about 10X realtime speed
# at present to run this you must have a directory at /home/sacarlson/motion
# Copyright (c) 2014  Scott Carlson  sacarlson@ipipi.com 

# this just cd's to the real path that the script is located so that it can be run from a symbolic link on my desktop
SELF_PATH=$(cd -P -- "$(dirname -- "$0")" && pwd -P) && SELF_PATH=$SELF_PATH/$(basename -- "$0") ; REALP=$(realpath $SELF_PATH) ; cd $(dirname -- "$REALP")

# lag time to wait for no motion detection before considered an event in seconds
lag=1800;

# event_image_count is the number of images after an event to add to video created
event_image_count=100

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
rm -f ./links/*.jpg

count=$event_image_count  
files=()
y=1
NOW=$(date +"%y_%m_%d_%H:%M")
FILE=$NOW.mp4
while read -rd '' date file;
do files["${date%.*}"]="$file"; done < <(find . -maxdepth 1 -name "*.jpg"  -type f -printf '%T@ %p\0');
tlast=$(date +%s)
#echo "tlast = $tlast \n"
for x in "${!files[@]}"; do
# printf "%d %s\n" "$x" "${files["$x"]}"
# echo "$tlast ... $x \n"
dif=$(( x - tlast )) 
# echo "dif = $dif \n"
 if [ $dif -gt $lag ]; then
   echo "event dif= $dif x= $x  file = ${files["$x"]} \n"
   count=0
   #xdg-open ${files["$x"]} 
   #eog ${files["$x"]} &
 fi
if [ $count -lt $event_image_count ]; then
counter=$(printf %04d $y)
echo "counter = $counter \n"
ln -s .${files["$x"]} ./links/$counter.jpg
((y+=1))
((count+=1))
fi
tlast=$x
done

cd ./links || exit;
avconv -r 30 -i %04d.jpg -vcodec mpeg4 $FILE
#avconv -r 30 -i %04d.jpg -s hd1080 -vcodec mpeg4 $FILE
cp $FILE ../../events_$FILE
echo "video conversion completed \n"
vlc ./$FILE
