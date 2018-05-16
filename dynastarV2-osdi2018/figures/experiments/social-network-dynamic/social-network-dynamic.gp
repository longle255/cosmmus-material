set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 22
set output './social-network-dynamic.ps'
set size 1,0.7

set grid ytics
set style data lines

set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 pi 30 ps 1
set style line 2 lc rgb '#000000' lt 1 lw 1 pt 4 pi 30 ps 1

set ylabel "Throughput (kcps)" offset 1.5

unset xlabel
set key top center

set yrange [0:30]

set xlabel "Time(s)"
set xrange [0:250]
set xtics 0,50,250

# set arrow from 185,0 to 185,30 filled back lw 4 lc rgb "red" lt 0 nohead
# set label 'arrowstyle 8:' at -520,-170 right

plot 'social-network-dynamic.dat' using 2 with linespoints ls 1 title "DynaStar",\
     '' using 3 with linespoints ls 2 title "DS-SMR",\
     'social-network-dynamic-repartition.dat' using 1:2:3:4 with vector lw 4 lc rgb "red" lt 0 nohead title "Repartitioning"
