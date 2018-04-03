#!/bin/bash
TMPFILE=`mktemp`
TMPDIR=`mktemp -d`
RCLONE="media/import"
PWD=`pwd`
wget "$1?dl=1" -O $TMPFILE
unzip -d $TMPDIR $TMPFILE
mv -v $TMPDIR/* ~/$RCLONE
rm $TMPFILE
