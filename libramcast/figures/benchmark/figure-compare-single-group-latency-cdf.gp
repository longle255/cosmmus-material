set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16
set output './graphs/figure-compare-single-group-latency-cdf.eps'

set size 0.7,0.5

set grid ytics
set grid xtics


# set title "Latency CDF for single group messages with single client"
set xrange [0:300]
set xtics 50
set ytics 0.2 
set key center right
set key samplen 2.5 spacing 1.2 font ",11"
set xlabel "Latency (us)"

set style line 1 lt 1 lw 0.8 pt 1 ps 0.5 pointinterval 30
set style line 2 lt 2 lw 0.8 pt 2 ps 0.5 pointinterval 30
set style line 3 lt 3 lw 1.5 pt 3 ps 0.5 pointinterval 30
set style line 4 lt 4 lw 1.5 pt 4 ps 0.5 pointinterval 30
set style line 5 lt 5 lw 2.5 pt 5 ps 0.5 pointinterval 30
set style line 6 lt 6 lw 2.5 pt 6 ps 0.5 pointinterval 30
set style line 7 lt 7 lw 2.5 pt 7 ps 0.5 pointinterval 30

plot 'data-aggregated/ramcast/cdf-1client-64B-vs-kpaxos.dat' using 1:2 with linespoints ls 1 title "RamCast - 64B",\
     'data-aggregated/ramcast/cdf-1client-1KB-vs-kpaxos.dat' using 1:2 with linespoints ls 2 title "RamCast - 1KB",\
     'data-aggregated/kpaxos/cdf-1client-64B.dat' using 1:2 with linespoints ls 3 title "Kernel Paxos - 64B",\
     'data-aggregated/kpaxos/cdf-1client-1KB.dat' using 1:2 with linespoints ls 4 title "Kernel Paxos - 1KB",\
     'data-aggregated/wbcast/cdf-1c-64B-1dest.dat' using 2:3 with linespoints ls 5 title "WBCast - 64B",\
     'data-aggregated/wbcast/cdf-1c-1KB-1dest.dat' using 2:3 with linespoints ls 6 title "WBCast - 1KB",\
     # 'data-aggregated/wbcast/cdf-1c-64B-1dest.dat' using 2:3 with linespoints ls 5 title "TODO:Fastcast - 64B",\
     # 'data-aggregated/wbcast/cdf-1c-1KB-1dest.dat' using 2:3 with linespoints ls 7 title "TODO:Fastcast - 1KB",\


system("pstopdf ./graphs/figure-compare-single-group-latency-cdf.eps -o ./graphs/figure-compare-single-group-latency-cdf.pdf && rm ./graphs/figure-compare-single-group-latency-cdf.eps")


