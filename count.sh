#!/bin/bash
RES="/work/04159/domij/res"
wc -l $RES/done.list
echo `ls $RES/bak/* | wc -l` "$RES/bak  tar file"
echo `ls $RES/alpha/*.dat | wc -l` "$RES/alpha lag.dat"
echo `ls -d $RES/alpha/model* | wc -l` "$RES/alpha models"
echo $((`ls $RES/alpha/model*/* | wc -l`/3)) "RES/alpha/model* mm files"
echo $((`ls $RES/BHsystem/* | wc -l`/3)) "RES/BHsystem/* BH system files"