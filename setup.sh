#!/bin/bash

:<<'END'
required:
-------
   $RES/files/mm_script
	job.sh 		  cp
	launcher.slurm    cp
   $RES/files/bak/
	mocca.ini	  cp
	mocca-072016	  cp

output:
-----
   $WORK/Models
	    ...
	/param
	    ct=0
	    paramlist_all
	    job.sh
	    launcher.slurm
	/stdout
END

RES='/work/04159/domij'
WORK='/scratch/04159/domij'

i=0
var_model=3 # King model
var_w0=6 
var_Mmax=100.0 # max star mass
var_amax=10747.0 # max semi-major ~50AU
var_equalM=0.8 # equal mass cass
var_seed=20160502 # 
var_tcrit=13050.0
var_vns=190.0 # NS kick v
var_vbh=190.0 # BH kick v

#models=(5 12 14 18 21)

if [ ! -d $WORK/Models ]; then
    mkdir $WORK/Models

    cd $WORK/Models

    for var_n in {500000,1000000} 
    do
	for var_z in {0.00005,0.0005,0.005}
	do
	    for var_fb in {0.0,0.1,0.2,0.3,0.4,0.5}
	    do
		for var_rt in {25,50,100}
		do
		    for var_rplum in {20.0,25.0,60.0}
		    do
			i=$((i+1))
			for j in {6..10}
			do
#		for k in {0..4}
#		do
#		    if [[ "$i" =~ ${models[k]} ]]
#		    then
#			rm -r model-$i-$j
			    mkdir model-$i-$j
			    cp $RES/files/bak/mocca.ini  model-$i-$j/.
			    cp $RES/files/bak/mocca-072016 model-$i-$j/mocca-$i-$j
			    sed -i.bak "s|var_n|${var_n}|g ;s|var_z|${var_z}|g ;s|var_fb|${var_fb}|g ;s|var_rplum|${var_rplum}|g ;s|var_rt|${var_rt}|g" model-$i-$j/mocca.ini
#	    	    fi
			done
		    done
		done
	    done
	done
    done
    mkdir $WORK/param
    mkdir $WORK/param/stdout
    touch $WORK/param/ct=0
    cp $RES/files/mm_script/job.sh $WORK/param/
    cp $RES/files/mm_script/launcher.slurm $WORK/param/

    for model in `ls -d $WORK/Models/model-* | rev | cut -d '/' -f 1 | rev`
    do
    	model=${model:6}
    	echo "./job.sh" $model "\$TACC_LAUNCHER_JID" >> $WORK/param/paramlist_all
    done

else
    echo "check existing Models"
fi
