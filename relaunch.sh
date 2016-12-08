#!/bin/bash
WORK="/scratch/04159/domij"
for model in `cat $WORK/res/unfinished.list | awk '{print $1}'`
do
    id=${model:6}
    echo "./job.sh" $id "\$TACC_LAUNCHER_JID" >> $WORK/paramlist
    dt=`date`
    echo $model $dt >> $WORK/res/check.list 
    rm $WORK/Models/$model/*.dat
done
rm $WORK/res/unfinished.list
