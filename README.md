These are the scripts to manage my GC simulations on TACC. 

## some note on extract data 

> \> *-bhe.dat

`12 tb0: period`

```
< escaped_binary.dat
    7   14  29  19  34  44  45  4   5
    Te  ik1 ik2 m1  m2  ap  ecc id1 id2
    Myr         M_o M_o r_o

awk '$14==14 || $29==14 {printf("%1.6e Gyrs %2d %2d %1.4e M_sol %1.4e M_sol %1.4e R_o %1.4e %d %d\n",$7/1000.0,$14,$29,$19,$34,$44,$45,$4,$5)}' escape_binary.dat
```

> \> *-bhr.dat

```
< snapshot.dat
    (2)   8   9   10  11  20  21  1   5   6
    Time  ik1 ik2 m1  m2  ap  ecc ib  id1 id2
    
awk '$4=="###" {TIME=$2} TIME>12000 && TIME<12050 && ($8==14 || $9==14) {printf("%1.8e Gyrs %2d %2d %1.8e M_sol %1.8e M_sol %1.8e R_o %1.8e %d %d %d\n",TIME/1000.0,$8,$9,$10,$11,$20,$21,$1,$5,$6)}' snapshot.dat
```

~~> \> *-sbhe.dat~~

```
< escape.dat
    2    6   8   7   4   5
    Time     m       id1 id2
    
    6:	object	= ikind 	1 - single star, 2 - binary
    7: (relaxation=0 or interaction=1)
    
awk '$8>100 {printf("%2.4f Gyrs %2d %5.4f M_sol %d %d %d\n",$2/1000.0,$6,$8,$7,$4,$5)}' escape.dat 
```

### Variable in Files

```
Qualities from escape_binary.dat (1:47)
		ik=14	m0		mass	MS age	radius	T1
	1st:	$14	 	$20		$19		$18		$23
	2nd:	$29	 	$35		$34		$33		$38
	kk		$2	position of the binary in the bin array
	timevo	$7	time of interaction in Myr
	z		$8	metalicity
	vss		$9	velocity in km/s
	ecc0		$10	binary e
	semi0	$11	semi-major in R_0?
	tb0		$12	binary period in days
	tphys1	$15

*	ap		$44	binary semi-major in R_0 (after interaction)
*	ecc		$45	binary e
	$46 $47	unknown	0,1,2,3?

Qualities from bhmergers-all-all.dat (1:65)
	data format: var>9?$var+20:$var

Qualities from escape.dat (1:13)
	tphys	$2	counting time
	iekind	$6	object	= ikind 	1 - single star, 2 - binary
	escmas	$8	Mass in M_o
	escene	$10	energy
	escang	$11	angular momentum
	esctim	$12	escape time


snapshot.dat
	bh-bh chirp mass 	-> chirpmass.dat
		(m1m2)**(3/5)/(m1+m2)**(1/5)
		$10,$11
	bh-bh period 
		T=2*pi*(a^3/G(m1+m2))**(1/2)
		a: $20, m1: $10, m2: $11
	e against period	-> e_T.dat
		e: $21, period

	bh-bh binding energy
	bh dynamical disruption timescale
	bh escapers binding energy
		

system.dat:
BH
	29 Max M for single bh
	31 Max M for bhb
	52 ns/bh escapers
	142 single bh
	154 bh-bh
	158 wd-bh
	161 ns-bh
	163 bh-ms
	164 bh-out of ms
	169 bh formed in collisions
	170 bh formed in binary mergers
	174 M of bh
	179 M of bh-bh
	182 M of by-ms
	239 trh

	17 half-mass radius		rhstats.dat
```
