cat <<EOF > /temp/out.sed
s/^ *//
/Refined/d
/WARNING/d
EOF

for i in 1 2 3 4 5 6 7 8 9 10
do         
           sed -f /temp/out.sed out.nkl | gawk -F, 'BEGIN {inside=0
			x=int(13/3)
                        print x
                        halt}
                     $1~/k/ {l=$NF; bin=int(l/100);
                             if ( $6==goal )
                                 { inside=1 }
                             else {inside=0};}
                     $1~/o/ { if ( inside==1 ) {
                                    
                                    sum[bin]=sum[bin]+$13
                                    n[bin]++
                                    }}
                     END { for (k in sum) {
		             temp = sum[k]/n[k]
                             print k " " temp 
                           }}
                ' goal=$i \
              | sort -n > /temp/k.$i 
done





