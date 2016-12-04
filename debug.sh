#!/bin/bash
model=$1
WORK="/scratch/04159/domij"

trials=`grep $model $(ls $WORK/param/paramlist* | grep -v all) | wc -l`
ofile=`grep $model $WORK/stdout/*.o | tail -n 1 | cut -d ':' -f 1 | rev | cut -d '/' -f 1 | rev`

list=`grep $model $(ls $WORK/param/paramlist* | grep -v all)`
pfile=`echo $list | cut -d ':' -f 1 | rev | cut -d '/' -f 1 | rev`

echo 'submitted' $trials 'times, in' $pfile 
echo 'last process output is' $ofile 
echo 'less' $WORK"/stdout/"$ofile