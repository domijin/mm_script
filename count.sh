#!/bin/bash
WORK="/scratch/04159/domij"
wc -l $WORK/res/done.list
echo `ls $WORK/res/bak/* | wc -l` "$WORK/res/bak  tar file"
echo `ls $WORK/res/alpha/*.dat | wc -l` "$WORK/res/alpha lag.dat"
echo `ls -d $WORK/res/alpha/model* | wc -l` "$WORK/res/alpha models"
echo `ls $WORK/res/alpha/model*/* | wc -l` "$WORK/res/alpha/model* mm files"
echo `ls $WORK/res/BHsystem/* | wc -l` "$WORK/res/BHsystem/* BH system files"
