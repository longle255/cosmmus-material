set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16
set output './graphs/figure-genuine-compare-latency-cdf.eps'

set size 0.7,0.5

set grid ytics
set grid xtics


# set title "Latency CDF for single group messages with single client"
set xrange [5:10]
set xtics 1
set ytics 0.2 
set key center right
set key samplen 2.5 spacing 1.2 font ",13"
set xlabel "Latency (us)"

set style line 1 lt 1 lw 0.8 pt 1 ps 1.0 pointinterval 30
set style line 2 lt 2 lw 0.8 pt 2 ps 1.0 pointinterval 30
set style line 3 lt 3 lw 1.5 pt 3 ps 1.0 pointinterval 30
set style line 4 lt 4 lw 1.5 pt 4 ps 1.0 pointinterval 30
set style line 5 lt 5 lw 2.5 pt 5 ps 1.0 pointinterval 30
set style line 6 lt 6 lw 2.5 pt 6 ps 1.0 pointinterval 30
set style line 7 lt 7 lw 2.5 pt 7 ps 1.0 pointinterval 30

plot 'data-aggregated/ramcast/xl170/broadcast-opt/genuine-latency-cdf-1.dat' using 1:2 with linespoints ls 1 title "1 group",\
     'data-aggregated/ramcast/xl170/broadcast-opt/genuine-latency-cdf-2.dat' using 1:2 with linespoints ls 2 title "2 groups",\
     'data-aggregated/ramcast/xl170/broadcast-opt/genuine-latency-cdf-4.dat' using 1:2 with linespoints ls 3 title "4 groups",\
     'data-aggregated/ramcast/xl170/broadcast-opt/genuine-latency-cdf-8.dat' using 1:2 with linespoints ls 4 title "8 groups",\


system("pstopdf ./graphs/figure-genuine-compare-latency-cdf.eps -o ./graphs/figure-genuine-compare-latency-cdf.pdf && rm ./graphs/figure-genuine-compare-latency-cdf.eps")


