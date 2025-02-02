set terminal postscript eps enhanced color solid lw 2 "Times-Roman" 16
set size 0.7,0.5
set grid ytics
set grid xtics
set output './graphs/figure-multi-dest-compare-latency-cdf-ramcast.eps'


set style data lines  # give gnuplot an arbitrary command
set style func linespoints

# set title "WBCast's Latency CDF for multi-group messages with single client"
set xrange [0:300]
set xtics 50
set ytics 0.2 
set key center right
set xlabel "Ramcast Latency (us)"
set key samplen 3.5 spacing 1.2 font ",13"
set style line 1 lt 1 lw 0.8 pt 1 ps 1.0 pointinterval 30
set style line 2 lt 2 lw 0.8 pt 2 ps 1.0 pointinterval 30
set style line 3 lt 3 lw 0.8 pt 3 ps 1.0 pointinterval 30
set style line 4 lt 4 lw 0.8 pt 4 ps 1.0 pointinterval 30

plot 'data-aggregated/ramcast/xl170/multi-dest-latency-cdf-1.dat' using 1:2 with linespoints ls 1 title "1 group ",\
     'data-aggregated/ramcast/xl170/multi-dest-latency-cdf-2.dat' using 1:2 with linespoints ls 2 title "2 groups",\
     'data-aggregated/ramcast/xl170/multi-dest-latency-cdf-4.dat' using 1:2 with linespoints ls 3 title "4 groups",\
     'data-aggregated/ramcast/xl170/multi-dest-latency-cdf-8.dat' using 1:2 with linespoints ls 4 title "8 groups",\

system("pstopdf ./graphs/figure-multi-dest-compare-latency-cdf-ramcast.eps -o ./graphs/figure-multi-dest-compare-latency-cdf-ramcast.pdf && rm ./graphs/figure-multi-dest-compare-latency-cdf-ramcast.eps")


