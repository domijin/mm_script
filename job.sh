#!/bin/bash
w_dir="/scratch/04159/domij"
model=$1
jid=$2

if [[ ! -d $w_dir/res ]]; then
mkdir $w_dir/res $w_dir/res/alpha $w_dir/res/bak $w_dir/res/BHsystem
fi

if [[ ! -d $w_dir/Models/model-$model ]]; then
    echo "warning: model" $model "does not exist" 
else
    cd $w_dir/Models/model-$model
    echo model-$model $jid
    pwd 

    while [[ ! -e model-scale.dat ]]  # while file not exist 
    do
	./mocca-$model >  $jid-output.dat
	sleep 2
    done

    if [[ -s $jid-output.dat ]]; then   # if file not empty then
	if [[ `tail -n 1 *-output.dat | awk '{print $1}'` == "restart.fil"  ]]; then

# ejected BH system
	    awk '$14==14 || $29==14 {printf("%1.6e Gyrs %2d %2d %1.4e M_sol %1.4e M_sol %1.4e R_o %1.4e %d %d\n",$7/1000.0,$14,$29,$19,$34,$44,$45,$4,$5)}' escape_binary.dat > $w_dir/res/BHsystem/$model-bhe.dat

# retained BH system
	    awk '$4=="###" {TIME=$2} TIME>12000 && TIME<12050 && ($8==14 || $9==14) {printf("%1.8e Gyrs %2d %2d %1.8e M_sol %1.8e M_sol %1.8e R_o %1.8f %d %d %d\n",TIME/1000.0,$8,$9,$10,$11,$20,$21,$1,$5,$6)}' snapshot.dat > $w_dir/res/BHsystem/$model-bhr.dat

# lag
	    cp lagrangi.dat $w_dir/res/alpha/$model-lag.dat

# for mm alpha
	    mkdir $w_dir/res/alpha/model-$model
	    cp mocca.ini end.dat system.dat $w_dir/res/alpha/model-$model/

# tar & clean up
	    tar -czf $w_dir/res/bak/$model.tar.gz snapshot.dat mocca* escape* lagrangi* system.dat profile.dat 

	    cd ..
	
	    ts=`stat --printf '%Y' model-$model/model-scale.dat`
	    tn=`stat --printf '%Y' model-$model/*-output.dat`
	    t=`bc -l <<< $((tn-ts))/3600.0`

	    rm -r model-$model
	    dt=`date`
	    echo model-$model $jid 'runtime:' $t $dt >> $w_dir/res/done.list
    	else
	    dt=`date`
	    echo model-$model $dt >> $w_dir/res/unfinished.list
    	fi
    else
	dt=`date`
	echo model-$model $dt >> $w_dir/res/aborted.list
    fi
fi
