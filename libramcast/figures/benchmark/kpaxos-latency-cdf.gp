set terminal postscript eps enhanced color solid lw 2 "Times-Roman" 16
set size 0.7,0.5
set grid ytics
set grid xtics
set output './graphs/kpaxos-latency-cdf-1client.eps'

set style data lines  # give gnuplot an arbitrary command
set style func linespoints

set title "Latency CDF for multi-group messages with single client"
set xrange [0:100]
set xtics 20
set ytics 0.2 
set key center right
set xlabel "Latency (us)"

set style line 1 lt 1 lw 0.8 pt 1 ps 0.5 pointinterval 30
set style line 2 lt 2 lw 0.8 pt 2 ps 0.5 pointinterval 30
set style line 3 lt 3 lw 0.8 pt 3 ps 0.5 pointinterval 30
set style line 4 lt 4 lw 0.8 pt 4 ps 0.5 pointinterval 30

plot 'data-aggregated/kpaxos/cdf-1client-64B.csv' using 1:2 with linespoints ls 1 title "TODO: add RamCast - 64B",\
     'data-aggregated/kpaxos/cdf-1client-1KB.csv' using 1:2 with linespoints ls 2 title "TODO: add RamCast - 1KB",\
     'data-aggregated/kpaxos/cdf-1client-64B.csv' using 1:2 with linespoints ls 3 title "Kernel Paxos - 64B",\
     'data-aggregated/kpaxos/cdf-1client-1KB.csv' using 1:2 with linespoints ls 4 title "Kernel Paxos - 1KB",\


system("pstopdf ./graphs/kpaxos-latency-cdf-1client.eps -o ./graphs/kpaxos-latency-cdf-1client.eps.pdf && rm ./graphs/kpaxos-latency-cdf-1client.eps")


