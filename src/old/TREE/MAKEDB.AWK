cat  class.txt  | tr A-Z a-z |  gawk '

function words(start,	x,i) {
	for(i=start;i<=NF;i++)
		x = x " " $i
	return x
}

function tag(str,	a,sep,i,n,y,z) {
	for(i in a) delete a[i]
	n=split(str,a,"\.")
	y=""
	z=""
	for(i=1;i<=n;i++)  {
		y=y z a[i]  
		z=","      }
	y=y
	return y	
}

$0 ~/^$/ { next }

{gsub(/\*\*/,"",$0)
 gsub(/\(.*\)/,"",$0) }
 $0 !~ /^[ 	]/ {
 	subs=0
        text=tag($1)
        print "class([",text,"],\"" words(2) "\")."
        next
}
	{subs++
	 print "class([",text,"," subs "],\"" words(1) "\")."
}' 