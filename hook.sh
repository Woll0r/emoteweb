#!/bin/bash

######################################################
# Hook script for executing the actual build of emote packs
######################################################

VIRTUALENV=/home/wolfgang/tadaenv
TADAPATH=/home/wolfgang/tada
EMOTEPATH=/home/wolfgang/emotes
WEBDIR=/var/www/emotes.cardboardbox.be

STARTDIR=`pwd`

error_exit() {
    echo 'fail' > $STARTDIR/status.txt
    exit 1
}

trap 'error_exit' ERR

echo 'updating' > $STARTDIR/status.txt

# Update emotes
cd $EMOTEPATH
git checkout master
git remote update
git pull --all

# Run Tada
$VIRTUALENV/bin/python $TADAPATH/main.py -i $EMOTEPATH -o $WEBDIR/output -n Ponypack

echo 'success' > $STARTDIR/status.txt
