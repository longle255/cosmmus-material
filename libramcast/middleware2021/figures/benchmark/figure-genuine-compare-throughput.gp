set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16
set output './graphs/figure-genuine-compare-throughput.eps'

set size 0.7,0.5

set grid ytics
set grid xtics

set style rect fc lt -1  fs solid 0.15 border lt 1 dt 2 lc rgb '#880088'
set style data histogram
set style histogram gap 1
set style fill pattern 0 border rgb "black"

# set title "Throughput for single-group messages at maximum load"
set ylabel "Throughput (Kmps)" offset 1
set yrange [0 : 1800]
set ytics 300
set xlabel "Number of groups"
set key samplen 3.5 spacing 1.2 font ",13"
set key top left

plot './data-aggregated/ramcast/single-dest-tp.dat' using 2:xtic(1) fs pattern 1 lc rgb '#888888' t "RamCast", \
     './data-aggregated/wbcast/single-dest-tp.dat' index 0 using 2:xtic(1) fs pattern 2 lc rgb '#888888' t "WBCast", \



system("pstopdf ./graphs/figure-genuine-compare-throughput.eps -o ./graphs/figure-genuine-compare-throughput.pdf && rm ./graphs/figure-genuine-compare-throughput.eps")
