set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16
set output './graphs/figure-multi-dest-compare-throughput.eps'

set size 0.7,0.5

set grid xtics
set grid ytics

set style rect fc lt -1  fs solid 0.15 border lt 1 dt 2 lc rgb '#880088'
set style data histogram
set style histogram gap 1
set style fill pattern 0 border rgb "black"


set title "Throughput for multi-group messages at maximum load"
set ylabel "Throughput (kcps)" offset 1
set yrange [0 : 250]
set ytics 50
set xlabel "Number of partitions"
set key samplen 3.5 spacing 1.2 font ",12"
set key top right

plot './data-aggregated/ramcast/xl170/multi-dest-tp.dat' using 2:xtic(1) fs pattern 1 lc rgb '#888888' t "RamCast", \
     './data-aggregated/wbcast/multi-dest-tp.dat' index 0 using 2:xtic(1) fs pattern 2 lc rgb '#888888' t "WBCast", \

system("pstopdf ./graphs/figure-multi-dest-compare-throughput.eps -o ./graphs/figure-multi-dest-compare-throughput.pdf && rm ./graphs/figure-multi-dest-compare-throughput.eps")
