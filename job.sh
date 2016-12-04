#!/bin/bash
RES="/work/04159/domij/res"
WORK="/scratch/04159/domij/Models"
model=$1
jid=$2

if [ ! -d $RES ]; then
mkdir $RES $RES/alpha $RES/bak $RES/BHsystem
fi

if [ ! -d $WORK/model-$model ]; then
    echo "warning: model" $model "does not exist" 
else
    cd $WORK/model-$model
    echo model-$model $jid
    pwd 

    while [ ! -e model-scale.dat ]
    do
	./mocca-$model >  $jid-output.dat
	sleep 2
    done

    if [ -s *-output.dat ]; then
	if [[ `tail -n 1 *-output.dat | awk '{print $1}'` == "restart.fil"  ]]; then

# ejected BH system
	    awk '$14==14 || $29==14 {printf("%2.4f Gyrs %2d %2d %5.4f M_sol %5.4f M_sol %2.4f AU %.4f %d %d\n",$7/1000.0,$14,$29,$19,$34,$44,$45,$4,$5)}' escape_binary.dat > $RES/BHsystem/$model-bhe.dat

# retained BH system
	    awk '$4=="###" {TIME=$2} TIME>12000 && TIME<12050 && ($8==14 || $9==14) {printf("%2.4f Gyrs %2d %2d %5.4f M_sol %5.4f M_sol %2.4f AU %.4f %d %d %d\n",TIME/1000.0,$8,$9,$10,$11,$29,$21,$1,$5,$6)}' snapshot.dat > $RES/BHsystem/$model-bhr.dat

# ejected single BH
	    awk '$8>100 {printf("%2.4f Gyrs %2d %5.4f M_sol %d %d %d\n",$2/1000.0,$6,$8,7,$4,$5)}' escape.dat > $RES/BHsystem/$model-sbhe.dat

# lag
	    cp lagrangi.dat $RES/alpha/$model-lag.dat

# for mm alpha
	    mkdir $RES/alpha/model-$model
	    cp mocca.ini end.dat system.dat $RES/alpha/model-$model/

# tar & clean up
	    tar -czf $RES/bak/$model.tar.gz snapshot.dat mocca* escape* lagrangi* system.dat profile.dat 

	    cd ..
	
	    ts=`stat --printf '%Y' model-$model/model-scale.dat`
	    tn=`stat --printf '%Y' model-$model/*-output.dat`
	    t=`bc -l <<< $((tn-ts))/3600.0`

	    rm -r model-$model
	    dt=`date`
	    echo model-$model $jid 'runtime:' $t $dt >> $RES/done.list
	fi
    else
	dt=`date`
	echo model-$model $dt >> $RES/unfinished.list
    fi
fi