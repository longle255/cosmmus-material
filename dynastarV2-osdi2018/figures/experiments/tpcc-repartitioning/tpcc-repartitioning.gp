set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16
set output './tpcc-repartitioning.ps'

set multiplot

#set size 0.7, 1.2

set grid ytics
set style data lines

set style line 1 lt 2 dashtype "-" lc rgb "black" lw 1.5

set key top center
set xrange [0:200]
set yrange [0:50000]
set xtics 0,50,200

set logscale y

unset xlabel
set format x ""
set size 1,0.5
set ylabel "Throughput (tnx/s)" offset 1.5
set origin 0,0.5
plot 'tpcc-repartitioning.dat' using 2 with line lt 3 lw 1.5 lc black title col

#unset logscale y
set origin 0,0
set ylabel "Latency (ms)" offset 1.5
set xlabel "Time(s)"
unset format x
plot 'tpcc-repartitioning.dat' using 3 with line lt 3 lw 1.5 lc black title col