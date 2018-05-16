set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 22
set output './social-network-oracle-load.ps'
set size 1,0.7
set grid ytics
set style data linespoints

set style line 1 lc rgb '#0060ad' lt 1 lw 1.5 pt 5 pi 30 ps 1
set style line 2 lc rgb '#000000' lt 1 lw 1 pt 4 pi 30 ps 1
set style line 3 lc rgb '#029a02' lt 1 lw 1 pt 6 pi 30 ps 1

set ylabel "CPU Load" offset 1.5
set xlabel "Time(s)"

plot 'social-network-oracle-load-2p.dat' using 2 every 2 with linespoints ls 1 title "2 partitions", \
     'social-network-oracle-load-4p.dat' using 2 every 2 with linespoints ls 2 title "4 partitions", \
     'social-network-oracle-load-8p.dat' using 2 every 2 with linespoints ls 3 title "8 partitions"
