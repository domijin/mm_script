#!/bin/bash
njobs=$1
jobs=8
Path="/scratch/04159/domij/param"
cd $Path

for i in `seq 1 $njobs`
do
    ct=`ls $Path | grep ct`
    ct=${ct:3}
    id=`ls $Path/paramlist* | grep -ve - -e _ | wc -l`
    id=$((id+1))
    
    tail -n $((ct+jobs)) $Path/paramlist_all | head -n $jobs > $Path/paramlist$id
    
    sed "s/paramlist/paramlist$id/g" $Path/launcher.slurm > $Path/$id-launcher.slurm
    sed -ri "s/-n [0-9]*/-n $((jobs+2))/g" $Path/$id-launcher.slurm
    sed -ri "s/-J MOCCA/-J MOCCA$id/g" $Path/$id-launcher.slurm
    
    sbatch $Path/$id-launcher.slurm

    mv $Path/ct=$ct $Path/ct=$((ct+jobs))
    echo $ct
done
