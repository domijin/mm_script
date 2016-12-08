#!/bin/bash
model=$1
WORK="/scratch/04159/domij"

trials=`grep \ $model $(ls $WORK/param/paramlist* | grep -v all) | wc -l`
ofile=`grep \ $model $WORK/param/stdout/*.o | tail -n 1 | cut -d ':' -f 1 | rev | cut -d '/' -f 1 | rev`  # stdout/   output file for job

list=`grep \ $model $(ls $WORK/param/paramlist* | grep -v all)`
pfile=`echo $list | cut -d ':' -f 1 | rev | cut -d '/' -f 1 | rev` # paramlist file

echo 'submitted' $trials 'times, in' $pfile 
echo 'last process output is' $ofile 
echo 'less' $WORK"/param/stdout/"$ofile
