#!c:/cygwin/bin/bash
set -x
DATA=$1.data
SORTS=$1.sort
SIZE=$2
GRAINS=$3
let DIV=$SIZE/$GRAINS
let DIV=$DIV-$DIV%1
echo $DIV 


if [ -f $DATA ]
then rm $DATA
fi

if [ -f $SORTS ]
then rm $SORTS
fi


set -x
"c:/program files/pl/bin/plcon.exe" -f arrt.pl -g "gos($2,$1),halt"  > $DATA


set +x
wc $DATA

cat $DATA \
|gawk -F, '{print $NF}'  \
|sort  \
|gawk -F, 'NR==1{first=$1}
           0==(NR % div) {x[NR/div]=$1; n++}
            END {for(i=1;i<=n;i++) {
                    print i "," first "," x[i]
                    first=x[i] }}' div=$DIV  > $SORTS

echo 1

gawk -F, 'pass==1 {n++
                   lower[$1]=$2 
                   upper[$1]=$3}
          pass==2 {for(i=1;i<NF;i++) {
                     printf("%s,",$i) }
                   class=n
                   for(i=1;i<=n;i++) {
                     if ( $NF >= lower[i] && $NF < upper[i] ) class=$i
                   }
                   print class}
                     ' pass==1 $SORTS pass==2 $DATA
