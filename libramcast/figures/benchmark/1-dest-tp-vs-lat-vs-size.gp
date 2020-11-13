set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 12
set output './graphs/1-dest-tp-vs-lat-vs-size.eps'
set encoding utf8

set size 0.5,0.5

set grid ytics
set grid xtics

set style data points

set title "Throughput and Latency with different message sizes"
set ylabel "Throughput (kmps)" offset 1
set yrange [0 : 250]
set ytics 50
set xrange [0 : 200]
set xtics 50
set xlabel "Latency (usec)"

set key samplen 3.5 spacing 1.2 font ",8"
set key top right

#plot './tp-vs-size.dat' using 3:2:1  with points pt 1 notitle
#plot './tp-vs-size.dat' using 3:2:1 w circles lc rgb "blue" title columnhead

plot './data-aggregated/1-dest-tp-vs-lat-vs-size.dat' using 3:2:1 every ::0::0 with point pt 1 lw 1.5 title "64B", \
    '' using 3:2:1 every ::1::1 with point pt 2 lw 1.5 title "512B", \
    '' using 3:2:1 every ::2::2 with point pt 3 lw 1.5 title "1KB", \
    '' using 3:2:1 every ::3::3 with point pt 3 lw 1.5 title "2KB", \
    '' using 3:2:1 every ::4::4 with point pt 4 lw 1.5 title "16KB", \
    '' using 3:2:1 every ::5::5 with point pt 5 lw 1.5 title "32KB", \
    '' using 3:2:1 every ::6::6 with point pt 6 lw 1.5 title "64KB"
