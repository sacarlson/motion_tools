#!/bin/bash 
# remove all images collected more than 7 days ago and create a video of what was captured in last 7 days
# this is ran from cron so we provide the full path here of setup

# this just cd's to the real path that the script is located so that it can be run from a symbolic link on my desktop or from cron
SELF_PATH=$(cd -P -- "$(dirname -- "$0")" && pwd -P) && SELF_PATH=$SELF_PATH/$(basename -- "$0") ; REALP=$(realpath $SELF_PATH) ; cd $(dirname -- "$REALP")
cd ./images || exit;
find . -name "*.jpg" -mtime +7 | xargs rm -Rf
cd ..
./make_video.sh
