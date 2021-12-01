for i in 2 3
do
cat << END > mutate.sed
s/if/000000/g
s/no/111111/g
s/then/222222/g
s/\([a-z]\)/\1$i/g
s/000000/if/g
s/111111/no/g
s/222222/then/g
END

sed -f mutate.sed t512.pl > t${i}99.pl
done
