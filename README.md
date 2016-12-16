
## extract data 

> \> *-bhe.dat

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