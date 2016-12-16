#!/bin/bash
ct=0  # running models
ctr=0 # waiting to be launched
ctd=0 # done models
ctc=0 # to be checked models
donelist=''
checklist=''
WORK="/scratch/04159/domij"
ttt=`stat --printf '%Y' $WORK/res/done.list`
for model in `cat $(ls $WORK/param/paramlist* | grep -ve _ -e - ) | awk '{print $2}'`
do
    if [ -d $WORK/Models/model-$model ]; then
	if [ -e $WORK/Models/model-$model/system.dat ]; then
	    stat=`echo model-$model`
	    Time=`awk '{print $2}' $WORK/Models/model-$model/system.dat | tail -n 1`
	    stat=`echo $stat':' $Time 'Gyrs'`
	    ts=`stat --printf '%Y' $WORK/Models/model-$model/model-scale.dat`
	    f_out=`ls -t $WORK/Models/model-$model/*-output.dat | head -1`
	    tn=`stat --printf '%Y' $f_out` 
	    t=`bc -l <<< $((tn-ts))/3600.0`

	    if [[ `tail -n 1 $f_out | awk '{print $1}'` == "restart.fil" ]]; then
		stat=`echo $stat'; done, processing data. runtime:' $t'hrs'`
		ctd=$((ctd+1))
		donelist=`echo $donelist $model`
	    else
		if [[ $((ttt-tn)) -gt 18000 ]]; then
		    stat=`echo $stat'; check for aborted! no update for 5+ hrs'`
		    ctc=$((ctc+1))
		    rstat=`tail -n 1 $WORK/Models/model-$model/system.dat | awk '{print $2}'`
		    checklist=`echo -e $checklist $WORK'/Models/model-'$model $rstat '\n'`
	        else
		    stat=`echo $stat'; uptime:' $t 'hrs'`
		    ct=$((ct+1))
		fi
	    fi
	    echo $stat
	else
	    ctr=$((ctr+1))
	    if grep -Fsq model-$model $WORK/paramlist; then
		echo model-$model 'marked as unfinished, check before bash relaunch.sh'
		ctr=$((ctr-1))
	    fi
	fi
    else
	ctd=$((ctd+1))
	donelist=`echo $donelist $model`
    fi
done
echo $ctd "done, list:" 
echo $donelist
echo $ctc "check, list:"
printf "%s\n" $checklist

echo "running:" $ct
echo "waiting:" $ctr
echo "done:" $ctd
echo "need check:" $ctc
echo "total:" $((ct+ctr+ctd+ctc))
echo "runing:" $ct  "need relaunch:" $ctr
