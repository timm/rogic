set ylabel "runtime (seconds)"
set xlabel "number of clauses"
cd "/temp"
plot 'k.2' title "k=2" with linesp 1 1,\
     'k.3' title "k=3" with linesp 0 2,\
     'k.4' title "k=4" with linesp 2 3,\
     'k.5' title "k=5" with linesp 0 4,\
     'k.6' title "k=6" with linesp 3 5,\
     'k.7' title "k=7" with linesp 0 6
cd "/usr/tim/src/pl/ht0"