#!/bin/bash
WORK="/scratch/04159/domij"

njob=2
Path=`echo $WORK'/param'`

for i in `seq 1 8`
do
    ct=`ls $Path | grep ct`
    ct=${ct:3}
    id=`ls $Path/paramlist* | grep -ve - -e _ | wc -l`
    id=$((id+1))
    
    tail -n $((ct+njob)) $WORK/paramlist_all | head -n $njob > $Path/paramlist$id
    
    sed "s/paramlist/paramlist$id/g" $Path/patch_launcher.slurm > $Path/$id-launcher.slurm
    sed -ri "s/-n [0-9]*/-n $((njob+2))/g" $Path/$id-launcher.slurm
    sed -ri "s/-J MOCCA/-J MOCCA$id/g" $Path/$id-launcher.slurm
    
    sbatch $Path$id-launcher.slurm

    mv $Path/ct=$ct $Path/ct=$((ct+njob))
    echo $ct
done