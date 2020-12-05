set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16
set output './graphs/figure-compare-single-group-throughput.eps'

set size 0.7,0.5

set grid ytics
set grid xtics

set style rect fc lt -1  fs solid 0.15 border lt 1 dt 2 lc rgb '#880088'
set style data histogram
set style histogram gap 1
set style fill pattern 0 border rgb "black"

# set title "Throughput for a single group at maximum load"
set ylabel "Throughput (Kmps)" offset 1
set yrange [0 : 250]
#unset xtics
set ytics 50
set xlabel "Message size"
set key samplen 3.5 spacing 1.2 font ",11"
set key top right

plot './data-aggregated/ramcast/tp-vs-kpaxos.dat' index 0 using ($2/1000):xtic(1) fs pattern 1 lc rgb '#888888' t "RamCast", \
     './data-aggregated/kpaxos/tp.dat' index 0 using ($2/1000):xtic(1) fs pattern 2 lc rgb '#888888' t "Kernel Paxos", \
     './data-aggregated/wbcast/tp.dat' index 0 using ($2/1000):xtic(1) fs pattern 3 lc rgb '#888888' t "WBCast", \

system("pstopdf ./graphs/figure-compare-single-group-throughput.eps -o ./graphs/figure-compare-single-group-throughput.pdf && rm ./graphs/figure-compare-single-group-throughput.eps")

