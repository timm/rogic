gawk 'NR > 1 {n[int($1/size)]++}
      END {
           for(i in n) {
             print string(width-n[i]," "),\
                   string(n[i],"*"), 
                   i*size + size/2}}

function string(n,c, i,s) {
  i=n
  while ( i-- ) {s= s c}
  return s
}' width=$1 size=$2 $3 | sort +1 -2 -n
