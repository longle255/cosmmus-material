set terminal postscript eps enhanced dashed color solid lw 2 "Helvetica" 18
set output './social-network-oracle-load.ps'
set size 1,0.7
set grid ytics
set style data linespoints

set style line 1 lc rgb "black" lt 2 dashtype 2 lw 1

set ylabel "CPU Load" offset 1.5
set xlabel "Time(s)"

plot 'social-network-oracle-load-2p.dat' using 2 every 2 with line lt 1 lw 0.5 lc rgb 'red'   title "2 partitions", \
     'social-network-oracle-load-4p.dat' using 2 every 2 with line lt 1 lw 1.5 lc rgb 'blue' title "4 partitions", \
     'social-network-oracle-load-8p.dat' using 2 every 2 with line ls 1 lw 1 lc rgb 'black'  title "8 partitions"
