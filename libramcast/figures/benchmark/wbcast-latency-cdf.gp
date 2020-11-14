set terminal postscript eps enhanced color solid lw 2 "Times-Roman" 16
set size 0.7,0.5
set grid ytics
set grid xtics
set output './graphs/wbcast-latency-cdf-1client.eps'
set datafile separator ","

set style data lines  # give gnuplot an arbitrary command
set style func linespoints

set title "WBCast's Latency CDF for multi-group messages with single client"
set xrange [0:1500]
set xtics 150
set ytics 0.2 
set key center right
set xlabel "Latency (us)"

set style line 1 lt 1 lw 0.8 pt 1 ps 0.5 pointinterval 30
set style line 2 lt 2 lw 0.8 pt 2 ps 0.5 pointinterval 30
set style line 3 lt 3 lw 0.8 pt 3 ps 0.5 pointinterval 30
set style line 4 lt 4 lw 0.8 pt 4 ps 0.5 pointinterval 30

plot 'data-aggregated/wbcast/cdf-1c-64B-1dest.csv' using 2:3 with linespoints ls 1 title "1 group ",\
     'data-aggregated/wbcast/cdf-1c-64B-2dest.csv' using 2:3 with linespoints ls 2 title "2 groups",\
     'data-aggregated/wbcast/cdf-1c-64B-4dest.csv' using 2:3 with linespoints ls 3 title "4 groups",\
     'data-aggregated/wbcast/cdf-1c-64B-8dest.csv' using 2:3 with linespoints ls 4 title "8 groups",\


system("pstopdf ./graphs/wbcast-latency-cdf-1client.eps -o ./graphs/wbcast-latency-cdf-1client.eps.pdf && rm ./graphs/wbcast-latency-cdf-1client.eps")


