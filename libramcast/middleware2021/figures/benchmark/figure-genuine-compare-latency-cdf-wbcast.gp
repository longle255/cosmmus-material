set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16
set output './graphs/figure-genuine-compare-latency-cdf-wbcast.eps'

set size 0.7,0.5

set grid ytics
set grid xtics


# set title "Latency CDF for single group messages with single client"
set xrange [50:450]
set xtics 50
set ytics 0.2 
set key center right
set key samplen 2.5 spacing 1.2 font ",13"
set xlabel "WBCast Latency (us)"

set style line 1 lt 1 lw 1 lc rgb "black" pt 1 ps 1.0 pointinterval 10
set style line 2 lt 2 lw 1 lc rgb "blue"  pt 2 ps 1.0 pointinterval 10
set style line 3 lt 3 lw 1 lc rgb "orange" pt 3 ps 1.0 pointinterval 10
set style line 4 lt 4 lw 1 lc rgb "red" pt 4 ps 1.0 pointinterval 10
set style line 5 lt 5 lw 2.5 pt 5 ps 1.0 pointinterval 10
set style line 6 lt 6 lw 2.5 pt 6 ps 1.0 pointinterval 10
set style line 7 lt 7 lw 2.5 pt 7 ps 1.0 pointinterval 10

plot 'data-aggregated/wbcast/cdf-1c-64B-1dest-1group.dat'  using 2:3 with linespoints ls 1 title "1 group",\
     'data-aggregated/wbcast/cdf-1c-64B-1dest-2groups.dat' using 2:3 with linespoints ls 2 title "2 groups",\
     'data-aggregated/wbcast/cdf-1c-64B-1dest-4groups.dat' using 2:3 with linespoints ls 3 title "4 groups",\
     'data-aggregated/wbcast/cdf-1c-64B-1dest-8groups.dat' using 2:3 with linespoints ls 4 title "8 groups"


system("pstopdf ./graphs/figure-genuine-compare-latency-cdf-wbcast.eps -o ./graphs/figure-genuine-compare-latency-cdf-wbcast.pdf && rm ./graphs/figure-genuine-compare-latency-cdf-wbcast.eps")


