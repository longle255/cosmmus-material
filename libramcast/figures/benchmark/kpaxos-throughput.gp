set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 12
set output './graphs/kpaxos-tp.eps'

set size 0.5,0.5

set grid ytics

set style rect fc lt -1  fs solid 0.15 border lt 1 dt 2 lc rgb '#880088'
set style data histogram
set style histogram gap 1
set style fill pattern 0 border rgb "black"


set title "Throughput for a single group at maximum load"
set ylabel "Throughput (kcps)" offset 1
set yrange [0 : 300]
set ytics 50
set xlabel "Message size"
set key top left

plot './data-aggregated/kpaxos/tp.dat' index 0 using ($2/1000):xtic(1) fs pattern 1 lc rgb '#888888' t "TODO: Add RamCast", \
     './data-aggregated/kpaxos/tp.dat' index 0 using ($2/1000):xtic(1) fs pattern 2 lc rgb '#888888' t "Kernel Paxos", \

system("pstopdf ./graphs/kpaxos-tp.eps -o ./graphs/kpaxos-tp.eps.pdf && rm ./graphs/kpaxos-tp.eps")

