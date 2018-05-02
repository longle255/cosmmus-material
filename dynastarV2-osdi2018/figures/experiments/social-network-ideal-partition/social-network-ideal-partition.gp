set terminal postscript eps enhanced color solid lw 2 "Times-Roman" 16
set output './social-network-ideal-partition.ps'

set style data linespoints
set grid ytics

set grid xtics

set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 pi -1 ps 1.5
set style line 2 lc rgb '#000000' lt 1 lw 2 pt 4 pi -1 ps 1.5

set pointintervalbox 1

set auto x
set xlabel "Number of partitions"

set yrange [0:30]
set ylabel "Throughput (kcps)"

set xrange [1:8]
plot 'social-network-ideal-partition.dat' using 2:xtic(1) with linespoints ls 1 title "DynaStar", \
        '' using 3:xtic(1) with linespoints ls 2 title "S-SMR~ {.1*}"