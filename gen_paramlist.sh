#!/bin/bash
# define work dir
WORK="/scratch/04159/domij"

if [[ -e $WORK/paramlist_all ]]; then
    mv $WORK/paramlist_all $WORK/paramlist_all.bak
fi

for model in `ls -d $WORK/Models/model-* | rev | cut -d '/' -f 1 | rev`
do
    model=${model:6}
    echo "./job.sh" $model "\$TACC_LAUNCHER_JID" >> $WORK/paramlist_all
done
