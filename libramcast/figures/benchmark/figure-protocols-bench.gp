set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 12
set output './graphs/figure-protocol-bench.eps'

set size 0.5,0.5

set grid ytics xtics

set style line 1  lt 1 lw 1.5 pt 1 ps 1
set style line 2  lt 2 lw 1.5 pt 2 ps 1
set style line 3  lt 3 lw 1.5 pt 3 ps 1
set style line 4  lt 4 lw 1.5 pt 4 ps 1
set style line 5  lt 5 lw 1.5 pt 5 ps 1
set style line 6  lt 6 lw 1.5 pt 6 ps 1
set style line 7  lt 7 lw 1.5 pt 7 ps 1


# set title "Performance of different protocols and verbs"
set ylabel "Latency (us)"
set yrange [1 : 256]
set logscale y 2
set xlabel "Message size" offset 1
set xtics ("64B" 0, "512B" 1, "1KB" 2, "2KB" 3, "4KB" 4, "8KB" 5, "16KB" 6, "32KB" 7)
# unset xtics
set key samplen 3.5 spacing 1.2 font ",11"
set key bottom right

plot './data-aggregated/ramcast/r320/protocol-bench-tcp-bench.dat' using 0:($3/2) with linespoints ls 1 title "TCP/IP", \
     './data-aggregated/ramcast/r320/protocol-bench-rdma-send-receive-bench.dat' using 0:($3/2) with linespoints ls 2 title "RDMA send/receive", \
     './data-aggregated/ramcast/r320/protocol-bench-rdma-read.dat' using 0:3 with linespoints ls 3 title "RDMA read", \
     './data-aggregated/ramcast/r320/protocol-bench-rdma-write.dat' using 0:($3/2) with linespoints ls 4 title "RDMA write"


system("pstopdf ./graphs/figure-protocol-bench.eps -o ./graphs/figure-protocol-bench.pdf && rm ./graphs/figure-protocol-bench.eps")
