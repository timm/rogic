set terminal _nextfe 
set output '/dev/null'
set noclip points
set clip one
set noclip two
set border
set boxwidth
set dummy x,y
set format x "%g"
set format y "%g"
set format z "%g"
set nogrid
set key 20,50,0
set nolabel
set noarrow
set nologscale
set offsets 0, 0, 0, 0
set nopolar
set angles radians
set noparametric
set view 60, 30, 1, 1
set samples 100, 100
set isosamples 10, 10
set surface
set nocontour
set clabel
set nohidden3d
set cntrparam order 4
set cntrparam linear
set cntrparam levels auto 5
set cntrparam points 5
set size 1,0.703417
set data style points
set function style lines
set noxzeroaxis
set noyzeroaxis
set tics in
set ticslevel 0.5
set xtics
set ytics
set ztics
set title "" 0,0
set notime
set rrange [0 : 10]
set trange [-5 : 5]
set urange [-5 : 5]
set vrange [-5 : 5]
set xlabel "" 0,0
set xrange [-3.82858e-16 : 100.100673]
set ylabel "" 0,0
set yrange [-5 : 50.654976]
set zlabel "" 0,0
set zrange [-10 : 10]
set autoscale r
set autoscale t
set autoscale xy
set autoscale z
set zero 1e-08
plot '/MyDisk/book/code/ch11/goals.dat'  title "goals", '/MyDisk/book/code/ch11/obst.dat'  title "barrier" with lines 1, '/MyDisk/book/code/ch11/simln_t2.dat'  title "robot" with dots
