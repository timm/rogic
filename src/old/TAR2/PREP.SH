OUTF="art1.pl"

if [ $# -lt 2 ]
then echo usage sh prep.sh costBreak chancesBreak
     echo e.g. sh prep.sh 0.4 0.4
     exit
fi

gawk -F, 'pass==1 {val[$1]=$2}
          pass==2 && header==0 {header=1
                                print ":- dataset(1)." > outf
                                cchop= (val["minc"]+(val["maxc"]-val["minc"])*tc)
                                chchop=(val["minch"]+(val["maxch"]-val["minch"])*tch)
				print "cost chop " cchop " chances chop " chchop
                                }
          pass==2 {print "data(" \
                         colPrint(1,NF-2) \
		         "," \
                         class($(NF-1),cchop)  \
                         class($(NF),chchop)  \
                         ").">>outf }

function class(num,t) {
    if (num > t) 
	return "hi"
    else return "lo"
}

function colPrint(i,j,   k,pre,s) {
    s= pre $i
    pre=","
    for(k=i+1;k<=j;k++) 
	s = s "" pre $k
    return s
}

' pass=1 art1.stats pass=2 tc=$1 tch=$2 outf="$OUTF" art1.data 

cat <<EOF 
cost,LogChances

hilo % <-- worst
lolo % 
hihi % 
lohi % <-- best

EOF

cat art1.stats


gawk -F, '{print $NF}' $OUTF  | sort | uniq -c