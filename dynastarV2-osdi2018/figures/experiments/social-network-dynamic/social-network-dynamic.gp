set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16
set output './social-network-dynamic.ps'

set size 0.7, 0.5

set grid ytics
set style data lines

set style line 1 lt 2 dashtype "-" lc rgb "black" lw 1.5
set style line 2 lt 2 dashtype "-" lc rgb "blue" lw 0.5

set ylabel "Throughput (kcps)" offset 1.5

unset xlabel
set key top center

set yrange [0:30]

set xlabel "Time(s)"
set xrange [0:250]
set xtics 0,50,250

set arrow from 185,0 to 185,30 filled back lw 4 lc rgb "red" lt 0 nohead
plot 'social-network-dynamic.dat' using 2 with line lt 3 lw 1.5 lc black title col,\
     '' using 3 with line lt 2 lw 0.5 lc black title col