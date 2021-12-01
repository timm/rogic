gawk -F, '{for(i=1;i<=NF;i++)
             item[i,$i]++}
        END {for(j in item) {
	#        print "[" j  "]"
		split(j,a,SUBSEP)
                print a[1] " " a[2] " " item[j]
	     }}' circuit.data | sort -n