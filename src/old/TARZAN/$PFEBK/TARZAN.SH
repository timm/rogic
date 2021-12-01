set -x
drive="d"
me="$drive:/usr/tim/src/pl/tarzan"
junk="c:/temp"
pl="c:/program files/pl/bin/plwin.exe" 

usage() {
	echo "usage: tarzan treeFile optionsFile"
	exit
}

for i in $1 $2
do
if [ ! -f $i ]
then    usage
fi
done

cat << EOF

Tarzan v1.0

George, George, 
George of the jungle,
Strong as he can be.
(watch out for that tree)
EOF

if [ ! -d $junk ]
then mkdir $junk
fi

all() {
   	gawk 'BEGIN{flag=0}
		NR> 3 && $0~/decision tree:/       {flag=1
	        	                next}
		$0~/tree saved/        {exit}
		flag==1                {print $0}' $1
}

simplify() {
	 gawk 'BEGIN{flag=0}
		NR > 3 && $0~/simplified decision tree:/ {flag=1
	        	                next}
		$0~/tree saved/        {exit}
		flag==1                {print $0}' $1
}

cat $1 \
| tr A-Z a-z \
| sed 's/<=/=</g' > $junk/tarzan_lc.learnt


if   grep "Simplified Decision Tree:" $1 >> /dev/null
then simplify $junk/tarzan_lc.learnt
else all      $junk/tarzan_lc.learnt
fi \
| gawk -F"|" -f $me/tree2pl.awk -v who="`basename  $1`"  \
| sed 's/_//'  \
| sed 's/<=/=</' > $junk/tarzan_pl.pl

 

(echo "treeFile('$junk/tarzan_pl.pl')."
echo ":- ['$me/tarzan.pl','$2'].") > $junk/tarzan_run.pl

"$pl" -G16M -L8M -f $junk/tarzan_run.pl  




