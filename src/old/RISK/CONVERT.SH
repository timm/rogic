echo ":- multifile db/1." > setup0.pl
echo ":- load_files([setup0" > all0.pl
for i in *.txt
do
	echo $i
	j0=`echo $i | tr A-Z a-z| sed 's/.txt//'`
	j=${j0}0
	gawk 'NR==1 { print "db("
                      gsub(/LAST_ /,"LAST_")}
               {gsub(/,,/,",-,")
		
	        gsub(/""/,"-")
		gsub(/,,/,",-,")
		
	        gsub(/""/,"-")
                gsub(/,[ 	]*$/,",-")
               print pname"("$0""}
	      NR==1 { print "))."}
	      NR > 1 { print ")."}
	      ' pname="$j0" fname="$j" $i > $j.pl
	
	echo  ","$j >> all0.pl
done
echo ",convert],[silent(on)])." >> all0.pl


