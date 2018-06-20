#!/bin/bash

REPO=$1
SUBDIR=`echo $REPO | sed -e 's%https://github.com/%%' -e 's%/%-%'`




mkdir -p data/commits
cd data
git clone $REPO $SUBDIR
cd $SUBDIR
git log --pretty=format:%s > ../commits/$SUBDIR.txt
cd ..
rm -rf ./$SUBDIR

