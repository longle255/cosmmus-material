set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16


set size 0.7,0.5

set grid ytics
set grid xtics

# ps: point size
set style line 1 lt 1 lw 1 pt 1 ps 0.5 pointinterval 3
set style line 2 lt 2 lw 1 pt 2 ps 0.5 pointinterval 3
set style line 3 lt 3 lw 1 pt 3 ps 0.5 pointinterval 3
set style line 4 lt 4 lw 1 pt 4 ps 0.5 pointinterval 3
set style line 5 lt 5 lw 1 pt 5 ps 0.5 pointinterval 30
set style line 6 lt 6 lw 1 pt 6 ps 0.5 pointinterval 30
set style line 7 lt 7 lw 1 pt 7 ps 0.5 pointinterval 30
set style line 8 lt 8 lw 1 pt 8 ps 0.5 pointinterval 30
set style line 9 lt 9 lw 1 pt 9 ps 0.5 pointinterval 30

# set title "Latency CDF with single destination when increasing package size"

set ytics 0.2 
set key samplen 3.5 spacing 1.2 font ",11"
set key center right
set xlabel "Latency(us)"
unset key

set xrange [0:15]
set xtics 3    
set output './graphs/figure-performance-vs-size-single-group-cdf-up-to-4k.eps'
# plot './data-aggregated/ramcast/xl170/latency-cdf-98b.dat' using 1:2 with linespoints ls 1 title "64B", \
#      './data-aggregated/ramcast/xl170/latency-cdf-512b.dat' using 1:2 with linespoints ls 2 title "512B", \
#      './data-aggregated/ramcast/xl170/latency-cdf-1024b.dat' using 1:2 with linespoints ls 3 title "1KB ", \
#      './data-aggregated/ramcast/xl170/latency-cdf-2048b.dat' using 1:2 with linespoints ls 4 title "2KB ", \
#      './data-aggregated/ramcast/xl170/latency-cdf-4096b.dat' using 1:2 with linespoints ls 5 title "4KB "

plot './data-aggregated/ramcast/xl170/broadcast-opt/latency-cdf-98b.dat' using 1:2 with linespoints ls 1 title "64B", \
     './data-aggregated/ramcast/xl170/broadcast-opt/latency-cdf-512b.dat' using 1:2 with linespoints ls 2 title "512B", \
     './data-aggregated/ramcast/xl170/broadcast-opt/latency-cdf-1024b.dat' using 1:2 with linespoints ls 3 title "1KB ", \
     './data-aggregated/ramcast/xl170/broadcast-opt/latency-cdf-2048b.dat' using 1:2 with linespoints ls 4 title "2KB ", \
     './data-aggregated/ramcast/xl170/broadcast-opt/latency-cdf-4096b.dat' using 1:2 with linespoints ls 5 title "4KB "

set xrange [0:120]
set xtics 20
set output './graphs/figure-performance-vs-size-single-group-cdf-from-4k.eps'
# plot './data-aggregated/ramcast/xl170/latency-cdf-4096b.dat' using 1:2 with linespoints ls 5 title "4KB ", \
#      './data-aggregated/ramcast/xl170/latency-cdf-8192b.dat' using 1:2 with linespoints ls 6 title "8KB ", \
#      './data-aggregated/ramcast/xl170/latency-cdf-16384b.dat' using 1:2 with linespoints ls 7 title "16KB", \
#      './data-aggregated/ramcast/xl170/latency-cdf-32768b.dat' using 1:2 with linespoints ls 8 title "32KB", \
#      './data-aggregated/ramcast/xl170/latency-cdf-65536b.dat' using 1:2 with linespoints ls 9 title "64KB"  

plot './data-aggregated/ramcast/xl170/broadcast-opt/latency-cdf-4096b.dat' using 1:2 with linespoints ls 5 title "4KB ", \
     './data-aggregated/ramcast/xl170/broadcast-opt/latency-cdf-8192b.dat' using 1:2 with linespoints ls 6 title "8KB ", \
     './data-aggregated/ramcast/xl170/broadcast-opt/latency-cdf-16384b.dat' using 1:2 with linespoints ls 7 title "16KB", \
     './data-aggregated/ramcast/xl170/broadcast-opt/latency-cdf-32768b.dat' using 1:2 with linespoints ls 8 title "32KB", \
     './data-aggregated/ramcast/xl170/broadcast-opt/latency-cdf-65536b.dat' using 1:2 with linespoints ls 9 title "64KB"  



system("pstopdf ./graphs/figure-performance-vs-size-single-group-cdf-up-to-4k.eps -o ./graphs/figure-performance-vs-size-single-group-cdf-up-to-4k.pdf && rm ./graphs/figure-performance-vs-size-single-group-cdf-up-to-4k.eps")
system("pstopdf ./graphs/figure-performance-vs-size-single-group-cdf-from-4k.eps -o ./graphs/figure-performance-vs-size-single-group-cdf-from-4k.pdf && rm ./graphs/figure-performance-vs-size-single-group-cdf-from-4k.eps")