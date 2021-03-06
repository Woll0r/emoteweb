#!/bin/bash

######################################################
# Hook script for executing the actual build of emote packs
######################################################

#VIRTUALENV=/home/wolfgang/tadaenv
#TADAPATH=/home/wolfgang/tada
#EMOTEPATH=/home/wolfgang/emotes
#WEBDIR=/var/www/emotes.cardboardbox.be

STARTDIR=`pwd`
INPATH=${EMOTE_PATH:=$STARTDIR/emotes}
WEBDIR=${EMOTE_WEBPATH:=$STARTDIR}

error_exit() {
    echo 'fail' > $STARTDIR/status.txt
    exit 1
}

trap 'error_exit' ERR

echo 'updating' > $STARTDIR/status.txt

# Get commit info
commiturl=$(curl -s -f https://api.github.com/repos/$EMOTE_REPO/git/refs/heads/master | jq -r '.object.url')
if [[ ! -z $commiturl ]]; then
    curl -s -o commit.json $commiturl
fi

# Update emotes
cd $INPATH
git checkout master
git remote update
git pull --all

# Run Tada
python $EMOTE_TADAPATH/main.py -i $INPATH -o $WEBDIR/output -n ${EMOTE_NAME:=Emotes}

echo 'success' > $STARTDIR/status.txt
