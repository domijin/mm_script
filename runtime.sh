#!/bin/bash
ct=0
ctr=0
ctd=0
donelist=''
WORK="/scratch/04159/domij"
for model in `cat $(ls $WORK/param/paramlist* | grep -ve _ -e - ) | awk '{print $2}'`
do
    if [ -d $WORK/Models/model-$model ]; then
	if [ -e $WORK/Models/model-$model/system.dat ]; then
	    stat=`echo model-$model`
	    Time=`awk '{print $2}' $WORK/Models/model-$model/system.dat | tail -n 1`
	    stat=`echo $stat ':' $Time 'Gyrs'`
	    ts=`stat --printf '%Y' $WORK/Models/model-$model/model-scale.dat`
	    tn=`stat --printf '%Y' $WORK/Models/model-$model/*-output.dat`
	    t=`bc -l <<< $((tn-ts))/3600.0`

	    if [[ `tail -n 1 $WORK/Models/model-$model/*-output.dat | awk '{print $1}'` == "restart.fil" ]]; then
		stat=`echo $stat '; done. runtime:' $t 'hrs'`
		ctd=$((ctd+1))
		donelist=`echo $donelist $model`
	    else
		stat=`echo $stat '; uptime:' $t 'hrs'`
		ct=$((ct+1))
	    fi
	    echo $stat
	else
	    echo model-$model "needs relaunch"
	    ctr=$((ctr+1))
	    flag=0
	    if [[ -e $WORK/res/unfinished.list ]]; then
		for rerun in `awk '{print $1}' $WORK/res/unfinished.list`
		do
		    if [[ "model-$model" == "$rerun" ]]; then
			flag=1
		    fi
		done
		if [[ $flag -eq 0 ]] && [[ ! -e $WORK/paramlist ]] ; then
		    echo model-$model "check to be sure" >> $WORK/res/unfinished.list 
		fi
	    fi
	fi
    else
#	echo model-$model 'is done'
	ctd=$((ctd+1))
	donelist=`echo $donelist $model`
    fi
done
echo $ctd "done, list:" 
echo $donelist
echo "runing:" $ct  "need relaunch:" $ctr
