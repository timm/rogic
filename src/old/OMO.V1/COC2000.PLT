set xrange [0.5:6.5]
set size 0.3,0.5
set nokey
set title "COCOMO.2000"
set yrange [0:8]
set ytics (0,2,4,6,8)
set xtics ("vl" 1, "l" 2, "n" 3, "h" 4, "vh" 5, "xh" 6)
set terminal postscript eps
set output "coc2000down.eps"
set yrange [0.5:2]
set ytics (0.5,1,1.5,2)
plot "coc2000.txt" using 1:2 title "a" with linesp 1 0,\
"coc2000.txt" using 1:3 title "b" with linesp 1 0,\
"coc2000.txt" using 1:4 title "c" with linesp 1 0,\
"coc2000.txt" using 1:5 title "" with linesp 1 0,\
"coc2000.txt" using 1:6 title "" with linesp 1 0,\
"coc2000.txt" using 1:7 title "" with linesp 1 0,\
"coc2000.txt" using 1:8 title "" with linesp 1 0,\
 "coc2000.txt" using 1:9 title "" with linesp 1 0
 pause -1

set yrange [0.5:2]
set ytics (0.5,1,1.5,2)
set output "coc2000up.eps"
plot "coc2000.txt" using 1:10 title "10" with linesp 1 0,\
"coc2000.txt" using 1:11 title "11" with linesp 1 0,\
"coc2000.txt" using 1:12 title "12" with linesp 1 0,\
"coc2000.txt" using 1:13 title "13" with linesp 1 0,\
"coc2000.txt" using 1:14 title "14" with linesp 1 0,\
"coc2000.txt" using 1:15 title "15" with linesp 1 0,\
"coc2000.txt" using 1:16 title "16" with linesp 1 0,\
"coc2000.txt" using 1:17 title "17" with linesp 1 0,\
 "coc2000.txt" using 1:18 title "" with linesp 1 0

pause -1

set yrange [0:8]
set ytics (0,2,4,6,8)
set output "coc2000cliff.eps"
plot "coc2000.txt" using 1:19 title "" with linesp 1 0,\
"coc2000.txt" using 1:20 title "" with linesp 1 0,\
"coc2000.txt" using 1:21 title "" with linesp 1 0,\
"coc2000.txt" using 1:22 title "" with linesp 1 0,\
"coc2000.txt" using 1:23 title "" with linesp 1 0

pause -1

set title "COCOMO.ga"
set yrange [0.5:2]
set ytics (0.5,1,1.5,2)
set output "cocgadown.eps"
plot "cocga.txt" using 1:2 title "a" with linesp 1 0,\
"cocga.txt" using 1:3 title "b" with linesp 1 0,\
"cocga.txt" using 1:4 title "c" with linesp 1 0,\
"cocga.txt" using 1:5 title "" with linesp 1 0,\
"cocga.txt" using 1:6 title "" with linesp 1 0,\
"cocga.txt" using 1:7 title "" with linesp 1 0,\
"cocga.txt" using 1:8 title "" with linesp 1 0,\
 "cocga.txt" using 1:9 title "" with linesp 1 0
 pause -1

set output "cocgaup.eps"
set yrange [0.5:2]
set ytics (0.5,1,1.5,2)
plot "cocga.txt" using 1:10 title "10" with linesp 1 0,\
"cocga.txt" using 1:11 title "11" with linesp 1 0,\
"cocga.txt" using 1:12 title "12" with linesp 1 0,\
"cocga.txt" using 1:13 title "13" with linesp 1 0,\
"cocga.txt" using 1:14 title "14" with linesp 1 0,\
"cocga.txt" using 1:15 title "15" with linesp 1 0,\
"cocga.txt" using 1:16 title "16" with linesp 1 0,\
"cocga.txt" using 1:17 title "17" with linesp 1 0,\
 "cocga.txt" using 1:18 title "" with linesp 1 0

pause -1
set yrange [0:8]
set ytics (0,2,4,6,8)
set output "cocgacliff.eps"
plot "cocga.txt" using 1:19 title "" with linesp 1 0,\
"cocga.txt" using 1:20 title "" with linesp 1 0,\
"cocga.txt" using 1:21 title "" with linesp 1 0,\
"cocga.txt" using 1:22 title "" with linesp 1 0,\
"cocga.txt" using 1:23 title "" with linesp 1 0

pause -1

set title "COCOMO.1983"

set yrange [0.5:2]
set ytics (0.5,1,1.5,2)
set output "coc1983down.eps"
plot "coc1983.txt" using 1:2 title "a" with linesp 1 0,\
"coc1983.txt" using 1:3 title "b" with linesp 1 0,\
"coc1983.txt" using 1:4 title "c" with linesp 1 0,\
"coc1983.txt" using 1:5 title "" with linesp 1 0,\
"coc1983.txt" using 1:6 title "" with linesp 1 0,\
"coc1983.txt" using 1:7 title "" with linesp 1 0,\
"coc1983.txt" using 1:8 title "" with linesp 1 0,\
 "coc1983.txt" using 1:9 title "" with linesp 1 0
 pause -1

set yrange [0.5:2]
set ytics (0.5,1,1.5,2)
set output "coc1983up.eps"
plot "coc1983.txt" using 1:10 title "10" with linesp 1 0,\
"coc1983.txt" using 1:11 title "11" with linesp 1 0,\
"coc1983.txt" using 1:12 title "12" with linesp 1 0,\
"coc1983.txt" using 1:13 title "13" with linesp 1 0,\
"coc1983.txt" using 1:14 title "14" with linesp 1 0,\
"coc1983.txt" using 1:15 title "15" with linesp 1 0,\
"coc1983.txt" using 1:16 title "16" with linesp 1 0,\
"coc1983.txt" using 1:17 title "17" with linesp 1 0,\
 "coc1983.txt" using 1:18 title "" with linesp 1 0

pause -1
set yrange [0:8]
set ytics (0,2,4,6,8)
set output "coc1983cliff.eps"
plot "coc1983.txt" using 1:19 title "" with linesp 1 0,\
"coc1983.txt" using 1:20 title "" with linesp 1 0,\
"coc1983.txt" using 1:21 title "" with linesp 1 0,\
"coc1983.txt" using 1:22 title "" with linesp 1 0,\
"coc1983.txt" using 1:23 title "" with linesp 1 0

pause -1
