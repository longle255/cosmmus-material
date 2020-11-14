set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 12
set output './graphs/kpaxos-tp-vs-lat-vs-size.eps'
set encoding utf8

set size 0.5,0.5

set grid ytics
set grid xtics

set style data points

set title "Throughput and Latency with different message sizes"
set xlabel "Throughput (kcps)" offset 1
set xrange [0 : 250]
set xtics 50
set yrange [0 : 500]
set ytics 50
set ylabel "Latency (usec)"

set key samplen 3.5 spacing 1.2 font ",8"
set key top right

plot './data-aggregated/kpaxos/tp-lat-64B.dat' using ($2/1000):1 w linespoints ls 1 title "TODO: RamCast - 64B", \
     './data-aggregated/kpaxos/tp-lat-1KB.dat' using ($2/1000):1 w linespoints ls 2 title "TODO: RamCast - 1KB", \
     './data-aggregated/kpaxos/tp-lat-64B.dat' using ($2/1000):1 w linespoints ls 3 title "Kernel Paxos - 64B", \
     './data-aggregated/kpaxos/tp-lat-1KB.dat' using ($2/1000):1 w linespoints ls 4 title "Kernel Paxos - 1KB", \

system("pstopdf ./graphs/kpaxos-tp-vs-lat-vs-size.eps -o ./graphs/kpaxos-tp-vs-lat-vs-size.eps.pdf && rm ./graphs/kpaxos-tp-vs-lat-vs-size.eps")
