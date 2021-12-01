#    
#    	G N U P L O T
#    	MS-Windows 32 bit version 3.7
#    	patchlevel 1
#    	last modified Fri Oct 22 18:00:00 BST 1999
#    
#    	Copyright(C) 1986 - 1993, 1998, 1999
#    	Thomas Williams, Colin Kelley and many others
#    
#    	Type `help` to access the on-line reference manual
#    	The gnuplot FAQ is available from
#    	<http://www.ucc.ie/gnuplot/gnuplot-faq.html>
#    
#    	Send comments and requests for help to <info-gnuplot@dartmouth.edu>
#    	Send bugs, suggestions and mods to <bug-gnuplot@dartmouth.edu>
#    
 set terminal postscript
# set output
set noclip points
set clip one
set noclip two
set bar 1.000000
set border 31 lt -1 lw 1.000
set xdata
set ydata
set zdata
set x2data
set y2data
set boxwidth
set dummy x,y
set format x "%g"
set format y "%g"
set format x2 "%g"
set format y2 "%g"
set format z "%g"
set angles radians
set grid nopolar
set nogrid #noxtics noytics noztics nox2tics noy2tics nomxtics nomytics nomztics nomx2tics nomy2tics lt 0 lw 1.000, lt 0 lw 1.000
set key title ""
set nokey
set nolabel
set label 1 "A: [3,1,1.05,1]= 1.13 " at 3.05, 1, 1.05 left norotate
set label 2 "B: [3,8,1.13,2]= 1.32" at 2.95, 8, 1.25  right norotate
set label 3 "C: [3,12,1.3,3]= 1.57" at 2.95, 12, 1.3 right norotate
set label 4 "D: [3,13,1.5,3]= ?" at 3.05, 13, 1.6 left norotate
set label 5 "E: [5,12,1.57,2]= 1.57" at 5, 11, 1.5 right norotate
set label 6 "F: [5,12,1.57,3]= ?" at 5.05, 12, 1.5 left norotate
set label 7 "G: [5,12,2,3]= 2.28" at 5.05, 12, 2.05 left norotate
set noarrow
set nolinestyle
set nologscale
set offsets 0, 0, 0, 0
set pointsize 1
set encoding default
set nopolar
set noparametric
set view 60, 30, 1, 1
set samples 100, 100
set isosamples 10, 10
set surface
set nocontour
set clabel '%8.3g'
set mapping cartesian
set nohidden3d
set cntrparam order 4
set cntrparam linear
set cntrparam levels auto 5
set cntrparam points 5
set size ratio 0.5 1,1
set origin 0,0
set data style points
set function style lines
set xzeroaxis lt -2 lw 1.000
set x2zeroaxis lt -2 lw 1.000
set yzeroaxis lt -2 lw 1.000
set y2zeroaxis lt -2 lw 1.000
set tics in
set ticslevel 0.5
set ticscale 1 0.5
set mxtics default
set mytics default
set mx2tics default
set my2tics default
set xtics border mirror norotate autofreq 
set ytics border mirror norotate autofreq 
set ztics border nomirror norotate autofreq 
set nox2tics
set noy2tics
set title "" 0.000000,0.000000  ""
set timestamp "" bottom norotate 0.000000,0.000000  ""
set rrange [ * : * ] noreverse nowriteback  # (currently [0.00000:10.0000] )
set trange [ * : * ] noreverse nowriteback  # (currently [-5.00000:5.00000] )
set urange [ * : * ] noreverse nowriteback  # (currently [-5.00000:5.00000] )
set vrange [ * : * ] noreverse nowriteback  # (currently [-5.00000:5.00000] )
set xlabel "x=granularity" 0.000000,0.000000  ""
set x2label "" 0.000000,0.000000  ""
set timefmt "%d/%m/%y\n%H:%M"
set xrange [ * : * ] noreverse nowriteback  # (currently [-10.0000:10.0000] )
set x2range [ * : * ] noreverse nowriteback  # (currently [-10.0000:10.0000] )
set ylabel "y=promising" 0.000000,0.000000  ""
set y2label "" 0.000000,0.000000  ""
set yrange [ * : * ] noreverse nowriteback  # (currently [-10.0000:10.0000] )
set y2range [ * : * ] noreverse nowriteback  # (currently [-10.0000:10.0000] )
set zlabel "z=useful" 0.000000,0.000000  ""
set zrange [ 1.00000 : 2.00000 ] noreverse nowriteback
set zero 1e-08
set lmargin -1
set bmargin -1
set rmargin -1
set tmargin -1
set locale "C"
set output "control.eps
set ticslevel 0.3
set view 20
splot "control" with linesp 1 1
#    EOF
