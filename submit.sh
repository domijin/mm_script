#!/bin/bash
RES="/work/04159/domij"
WORK="/scratch/04159/domij"
njob=16

runid=`ls $WORK/stdout/ | wc -l`
if [ ! -e $WORK/paramlist ]; then
    if [ -e $RES/res/unfinished.list ]; then
	njob=`cat $RES/unfinished.list | wc -l`
	bash $RES/files/scripts/relaunch.sh
	if [ $njob -le 8 ]; then
	    sed -ri.bak "s/SBATCH -N [0-9]*/SBATCH -N 1/g" $WORK/relauncher.slurm
	    sed -ri.bak "s/SBATCH -n [0-9]*/SBATCH -n $((njob*2))/g" $WORK/relauncher.slurm
	    sbatch $WORK/relauncher.slurm
	    pfile=`ls $WORK/paramlist* | grep -ve - -e _ | tail -n 1`
	    runs=`ls $pfile* | wc -l`
	    while [ `ls $WORK/stdout/ | wc -l` -eq $runid ]
	    do
		sleep 5
	    done
	    ofile=`ls $WORK/stdout/ | tail -n 1`
	    while [[ `cat $WORK/stdout/$ofile | wc -l` -lt $((njob*3+9)) ]]
	    do
		sleep 2
	    done
	    mv $WORK/paramlist $pfile-$((runs+1))
	else
	    sed -ri.bak "s/SBATCH -N [0-9]*/SBATCH -N $((njob/16+1))/g" $WORK/relauncher.slurm
	    sed -ri.bak "s/SBATCH -n [0-9]*/SBATCH -n $((njob+1))/g" $WORK/relauncher.slurm
	    sbatch $WORK/relauncher.slurm
            pfile=`ls $WORK/paramlist* | grep -ve - -e _ | tail -n 1`
            runs=`ls $pfile* | wc -l`
	    while [ `ls $WORK/stdout/ | wc -l` -eq $runid ]
            do
		sleep 5
            done
            ofile=`ls $WORK/stdout/ | tail -n 1`
            while [[ `cat $WORK/stdout/$ofile | wc -l` -lt $((njob*3+9)) ]]
            do
                sleep 2
            done
            mv $WORK/paramlist $pfile-$((runs+1))
	fi
    else
	ct=`ls $WORK | grep ct`
	ct=${ct:3}
	tail -n $((ct+njob)) $WORK/paramlist_all | head -n $njob > $WORK/paramlist
	sbatch $WORK/launcher.slurm
	id=`ls $WORK/paramlist* | grep -ve - -e _ | wc -l`
	while [ `ls $WORK/stdout/ | wc -l` -eq $runid ]
	do
            sleep 5
	done
        ofile=`ls $WORK/stdout/ | tail -n 1`
        while [[ `cat $WORK/stdout/$ofile | wc -l` -lt $((njob*3+9)) ]]
        do
            sleep 2
        done
	mv $WORK/paramlist $WORK/paramlist$((id+1))
	mv $WORK/ct=$ct $WORK/ct=$((ct+njob))
    fi
else
    echo "warning: check paramlist"
fi