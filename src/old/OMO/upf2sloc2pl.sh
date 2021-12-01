cat upf2sloc.txt | tr A-Z a-z | gawk '{
 q="\"";
 sep="";
 str=""
 for(i=1;i<=(NF-2);i++) {
      str= str sep $i
      sep=" "}
 print "upf2sloc(" q str q "," $NF ")."
}' > upf2sloc.pl