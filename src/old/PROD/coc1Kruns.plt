set size 0.5,0.5
set xrange [0:1050]
set yrange [0:20000]
set xtics (0,250,500,750,1000)
set ytics (0,5000,10000,15000,20000)
set ylabel "staff months"
set xlabel "1000 runs, sorted by staff months"
set terminal postscript eps
set output "coc1Kruns.eps"
plot "coc1Kruns.dat" title "" with points 1
