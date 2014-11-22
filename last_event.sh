#!/bin/bash 
# display files that were modified at least $lag time since last modified file
# this will detect image motion detected when no motion has been seen for some time
# lag is in secounds
# open the last imaged event in image viewer that you can go forward and back to view each frame
# Copyright (c) 2014  Scott Carlson  sacarlson@ipipi.com 

# this just cd's to the real path that the script is located so that it can be run from a symbolic link on my desktop
SELF_PATH=$(cd -P -- "$(dirname -- "$0")" && pwd -P) && SELF_PATH=$SELF_PATH/$(basename -- "$0") ; REALP=$(realpath $SELF_PATH) ; cd $(dirname -- "$REALP")

# in this case lag time of 30 minutes or 1800 seconds
lag=1800;
  
if [ -d "./images" ]; then
  cd ./images || exit ;
else
  mkdir ./images || exit ;
  cd ./images || exit ;
fi

files=()
while read -rd '' date file;
do files["${date%.*}"]="$file"; done < <(find . -maxdepth 1 -name "*.jpg"  -type f -printf '%T@ %p\0');
tlast=$(date +%s)
#echo "tlast = $tlast \n"
for x in "${!files[@]}"; do
# printf "%d %s\n" "$x" "${files["$x"]}"
# echo "$last ... $x \n"
dif=$(( x - tlast )) 
# echo "dif = $dif \n"
 if [ $dif -gt $lag ]; then
   #echo "event dif= $dif x= $x  file = ${files["$x"]} \n"
   lastx=$x
   lastdif=$dif
 fi
tlast=$x
done
echo "event dif= $lastdif x= $lastx  file = ${files["$lastx"]} \n"
xdg-open ${files["$lastx"]}
