BEGIN   {q="\'"
         parent[1]=1
	print "node("q who q",1,1,t,t)."
        }       
	{n++
         parent[NF]=n}
NF > 0 && $NF~/\(/ {
	tmp[0]=split($NF,tmp,":")
	sub(/ \(.*/,"",tmp[2])
	tmp[2]=trim(tmp[2])
	print "node(" q who q \
              ","     n            \
              ","     parent[NF-1] \
              ","     tmp[1]       \
              ","     tmp[2]   \
              "). " \
              ":- ensure(range(classt," tmp[2] "))."
	next
}
NF > 0 {
	sub(/:/,"")
	trim($NF)
	print "node(" q who q \
              ","     n            \
              ","     parent[NF-1] \
              ","     trim($NF)    \
              ","     "t"          \
              ")."
}
function trim(s1,   s2) {
	s2=s1
	sub(/^[ 	]*/,"",s2)
	sub(/[ 	]*$/,"",s2)
	return s2
	}
