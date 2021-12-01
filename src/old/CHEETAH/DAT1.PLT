set nokey
set xlabel "cost"
set ylabel "log(chances)"
set size 0.5,0.5
set title "ART1: 1000 runs- variations=0; Apr-0-4-01" 0.000000,0.000000  ""
set yrange [-140:-60]
set xrange [320:460]
set terminal postscript 
set output 'dat.eps'
plot "dat"

set output 'proj.eps'
set title "ART1: 1000 runs-  variations=0.3; Apr-0-4-01" 0.000000,0.000000  ""
plot "proj.dat"