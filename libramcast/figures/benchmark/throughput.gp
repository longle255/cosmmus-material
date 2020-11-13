set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 12
set output './graphs/multi-dest-tp.eps'

set size 0.5,0.5

set grid ytics

set style rect fc lt -1  fs solid 0.15 border lt 1 dt 2 lc rgb '#880088'
set style data histogram
set style histogram gap 1
set style fill pattern 0 border rgb "black"


set title "Throughput for multi-group messages at maximum load"
set ylabel "Throughput (kcps)" offset 1
set yrange [0 : 300]
set ytics 50
set xlabel "Number of partitions"
set key top left

plot './data-aggregated/multi-dest-tp.dat' using 2:xtic(1) fs pattern 1 lc rgb '#888888' notitle


#==================================================================
set output './graphs/single-dest-tp.eps'
set title "Throughput for single-group messages at maximum load"
set ylabel "Throughput (kcps)" offset 1
set yrange [0 : 1800]
set ytics 300
set xlabel "Number of partitions"
# unset xtics
set key top left

plot './data-aggregated/single-dest-tp.dat' using 2:xtic(1) fs pattern 1 lc rgb '#888888' notitle

