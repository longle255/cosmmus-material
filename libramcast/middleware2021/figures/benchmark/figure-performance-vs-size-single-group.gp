set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16


set size 0.7,0.5

set grid ytics
set grid xtics

set style line 1  lt 1 lw 1 pt 1 ps 1
set style line 2  lt 2 lw 1 pt 2 ps 1
set style line 3  lt 3 lw 1 pt 3 ps 1
set style line 4  lt 4 lw 1 pt 4 ps 1
set style line 5  lt 5 lw 1 pt 5 ps 1
set style line 6  lt 6 lw 1 pt 6 ps 1
set style line 7  lt 7 lw 1 pt 7 ps 1
set style line 8  lt 8 lw 1 pt 8 ps 1
set style line 9  lt 9 lw 1 pt 9 ps 1
set style line 1 lt 1 lw 1 lc rgb "black" pt 1 ps 1.0
set style line 2 lt 2 lw 1 lc rgb "blue"  pt 2 ps 1.0
set style line 3 lt 3 lw 1 lc rgb "orange" pt 3 ps 1.0
set style line 4 lt 4 lw 1 lc rgb "red" pt 4 ps 1.0
set style line 5 lt 5 lw 2.5 pt 5 ps 1.0 pointinterval 10
set style line 6 lt 6 lw 2.5 pt 6 ps 1.0 pointinterval 10
set style line 7 lt 7 lw 1.5 pt 7 ps 1.0 pointinterval 100
set style line 8 lt 8 lw 1.5 pt 8 ps 1.0 pointinterval 100
set style line 9 lt 9 lw 1.5 pt 9 ps 1.0 pointinterval 10
set style line 10 lt 10 lw 1.5 pt 10 ps 1.0 pointinterval 15


# set title "Performance with single destination when increasing package size"
set ylabel "Latency (us)" offset 1
set xrange [0 : 250]
set xtics 50
set xlabel "Throughput (Kmps)" offset 0
# set logscale x

set key samplen 3.5 spacing 1.2 font ",13"
set key top left

set yrange [0 : 30]
set ytics 5
set output './graphs/figure-performance-vs-size-single-group-up-to-4k.eps'
plot './data-aggregated/ramcast/xl170/broadcast-opt/1-dest-tp-vs-lat-vs-size-vs-load-98b.dat' using 2:3 with linespoints ls 1 title "64B", \
     './data-aggregated/ramcast/xl170/broadcast-opt/1-dest-tp-vs-lat-vs-size-vs-load-512b.dat' using 2:3 with linespoints ls 2 title "512B", \
     './data-aggregated/ramcast/xl170/broadcast-opt/1-dest-tp-vs-lat-vs-size-vs-load-1024b.dat' using 2:3 with linespoints ls 3 title "1KB ", \
     './data-aggregated/ramcast/xl170/broadcast-opt/1-dest-tp-vs-lat-vs-size-vs-load-2048b.dat' using 2:3 with linespoints ls 4 title "2KB "
#     './data-aggregated/ramcast/xl170/broadcast-opt/1-dest-tp-vs-lat-vs-size-vs-load-4096b.dat' using 2:3 with linespoints ls 5 title "4KB "

set yrange [0 : 150]
set ytics 25
set key top right
set xrange [0 : 250]
set output './graphs/figure-performance-vs-size-single-group-from-4k.eps'
plot './data-aggregated/ramcast/xl170/broadcast-opt/1-dest-tp-vs-lat-vs-size-vs-load-4096b.dat' using 2:3 with linespoints ls 1 title "4KB ", \
     './data-aggregated/ramcast/xl170/broadcast-opt/1-dest-tp-vs-lat-vs-size-vs-load-8192b.dat' using 2:3 with linespoints ls 2 title "8KB ", \
     './data-aggregated/ramcast/xl170/broadcast-opt/1-dest-tp-vs-lat-vs-size-vs-load-16384b.dat' using 2:3 with linespoints ls 3 title "16KB", \
     './data-aggregated/ramcast/xl170/broadcast-opt/1-dest-tp-vs-lat-vs-size-vs-load-32768b.dat' using 2:3 with linespoints ls 4 title "32KB"
#     './data-aggregated/ramcast/xl170/broadcast-opt/1-dest-tp-vs-lat-vs-size-vs-load-65536b.dat' using 2:3 with linespoints ls 5 title "64KB",

system("pstopdf ./graphs/figure-performance-vs-size-single-group-up-to-4k.eps -o ./graphs/figure-performance-vs-size-single-group-up-to-4k.pdf && rm ./graphs/figure-performance-vs-size-single-group-up-to-4k.eps")
system("pstopdf ./graphs/figure-performance-vs-size-single-group-from-4k.eps -o ./graphs/figure-performance-vs-size-single-group-from-4k.pdf && rm ./graphs/figure-performance-vs-size-single-group-from-4k.eps")