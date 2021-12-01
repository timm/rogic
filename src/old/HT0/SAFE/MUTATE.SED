cat << END > mutate.sed
s/if/00000/g
s/no/11111/g
s/then/222222/g
s/\([a-z]\)/\1#$1
END