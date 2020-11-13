set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 12
set output './graphs/1-dest-tp-vs-lat-vs-size-vs-load.eps'

set size 0.5,0.5

set grid ytics

set style line 1  lt 1 lw 1.5 pt 1 ps 1
set style line 2  lt 2 lw 1.5 pt 2 ps 1
set style line 3  lt 3 lw 1.5 pt 3 ps 1
set style line 4  lt 4 lw 1.5 pt 4 ps 1
set style line 5  lt 5 lw 1.5 pt 5 ps 1
set style line 6  lt 6 lw 1.5 pt 6 ps 1
set style line 7  lt 7 lw 1.5 pt 7 ps 1


set title "Performance with single destination when increasing package size"
set ylabel "Latency (us)"
set yrange [0 : 350]
set xlabel "Throughput (kmps)" offset 1
set xrange [0 : 250]
set xtics 50
# unset xtics
set key samplen 3.5 spacing 1.2 font ",9"
set key top right

plot './data-aggregated/1-dest-tp-vs-lat-vs-size-vs-load-98b.dat' using 2:3 with linespoints ls 1 title "64B", \
     './data-aggregated/1-dest-tp-vs-lat-vs-size-vs-load-512b.dat' using 2:3 with linespoints ls 2 title "512B", \
     './data-aggregated/1-dest-tp-vs-lat-vs-size-vs-load-1024b.dat' using 2:3 with linespoints ls 3 title "1KB ", \
     './data-aggregated/1-dest-tp-vs-lat-vs-size-vs-load-2048b.dat' using 2:3 with linespoints ls 4 title "2KB ", \
     './data-aggregated/1-dest-tp-vs-lat-vs-size-vs-load-16384b.dat' using 2:3 with linespoints ls 5 title "16KB", \
     './data-aggregated/1-dest-tp-vs-lat-vs-size-vs-load-32768b.dat' using 2:3 with linespoints ls 6 title "32KB", \
     './data-aggregated/1-dest-tp-vs-lat-vs-size-vs-load-65536b.dat' using 2:3 with linespoints ls 7 title "64KB",
