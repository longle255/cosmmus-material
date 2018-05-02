set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16
set output './tpcc-repartitioning.ps'


set lmargin at screen 0.15
set rmargin at screen 0.95

set multiplot

set size 0.5,0.35

set grid ytics
set style data lines
set style line 1 lt 2 dashtype "-" lc rgb "black" lw 1.5

set key top center
set xrange [0:200]
set yrange [0:50000]
set xtics 0,50,150

set logscale y

unset xlabel
set format x ""
set ylabel "Throughput (tnx/s)" offset 1.5
set origin 0,0.64
plot 'tpcc-repartitioning.dat' using 2 with line lt 3 lw 1.5 lc black notitle


set origin 0,0.32
set ylabel "Latency (ms)" offset 1.5
plot 'tpcc-repartitioning.dat' using 3 with line lt 3 lw 1.5 lc black notitle


set origin 0,0
unset logscale y
set yrange [0:100]
set ylabel "Global tnx (%)" offset 0
set xlabel "Time(s)"
unset format x
plot 'tpcc-repartitioning.dat' using 4 with line lt 3 lw 1.5 lc black notitle