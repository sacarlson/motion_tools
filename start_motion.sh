#!/bin/bash

# this just cd's to the real path that the script is located so that it can be run from a symbolic link on my desktop or from cron
SELF_PATH=$(cd -P -- "$(dirname -- "$0")" && pwd -P) && SELF_PATH=$SELF_PATH/$(basename -- "$0") ; REALP=$(realpath $SELF_PATH) ; cd $(dirname -- "$REALP")

cd ./images || exit;
motion -c ../motion.conf
