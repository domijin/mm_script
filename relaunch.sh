#!/bin/bash
RES="/work/04159/domij/res"
WORK="/scratch/04159/domij"
for model in `cat $RES/unfinished.list | awk '{print $1}'`
do
    id=${model:6}
    echo "./job.sh" $id "\$TACC_LAUNCHER_JID" >> $WORK/paramlist
    dt=`date`
    echo $model $dt >> $RES/check.list 
    rm $WORK/Models/$model/*.dat
done
rm $RES/unfinished.list