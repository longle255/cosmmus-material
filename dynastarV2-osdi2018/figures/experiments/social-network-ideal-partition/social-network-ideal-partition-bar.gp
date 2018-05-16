set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 24
set output './social-network-ideal-partition.ps'
set style data histogram
set style fill pattern 0 border rgb "black"

set grid ytics


set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 pi -1 ps 1.5
set style line 2 lc rgb '#000000' lt 1 lw 2 pt 4 pi -1 ps 1.5

set pointintervalbox 1

set auto x
set xlabel "Number of partitions"

set yrange [0:12]
set ylabel "Throughput (kcps)"

#set xrange [1:12]

set key top left

plot 'social-network-ideal-partition.dat' using 4:xtic(1) fs pattern 0 lc rgb '#888888' title 'DS-SMR', \
        '' using 3:xtic(1) fs pattern 1 lc rgb '#888888' title "S-SMR~ {.1*}", \
        '' using 2:xtic(1) fs pattern 2 lc rgb '#888888' title 'DynaStar'
