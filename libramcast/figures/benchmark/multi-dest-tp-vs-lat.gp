set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 12
set output './graphs/multi-dest-tp-vs-lat.eps'

set size 0.5,0.5

set grid ytics

set style line 1  lt 1 lw 1.5 pt 1 ps 1
set style line 2  lt 2 lw 1.5 pt 2 ps 1
set style line 3  lt 3 lw 1.5 pt 3 ps 1
set style line 4  lt 4 lw 1.5 pt 4 ps 1

set title "RamCast - Throughput for multi-group messages when increasing number of client"
set ylabel "Latency (us)"
set yrange [0 : 250]
set xlabel "Throughput (kmps)" offset 1
set xrange [0 : 250]
set xtics 50
# unset xtics
set key samplen 3.5 spacing 1.2 font ",9"
set key top right

plot './data-aggregated/multi-dest-tp-vs-lat-1.dat' using 2:3 with linespoints ls 1 title "1 group", \
     './data-aggregated/multi-dest-tp-vs-lat-2.dat' using 2:3 with linespoints ls 2 title "2 groups", \
     './data-aggregated/multi-dest-tp-vs-lat-4.dat' using 2:3 with linespoints ls 3 title "4 groups", \
     './data-aggregated/multi-dest-tp-vs-lat-8.dat' using 2:3 with linespoints ls 4 title "8 groups", \


system("pstopdf ./graphs/multi-dest-tp-vs-lat.eps -o ./graphs/multi-dest-tp-vs-lat.eps.pdf && rm ./graphs/multi-dest-tp-vs-lat.eps")


################
set output './graphs/wbcast-multi-dest-tp-vs-lat.eps'

set size 0.5,0.5

set grid ytics

set style line 1  lt 1 lw 1.5 pt 1 ps 1
set style line 2  lt 2 lw 1.5 pt 2 ps 1
set style line 3  lt 3 lw 1.5 pt 3 ps 1
set style line 4  lt 4 lw 1.5 pt 4 ps 1

set title "WBCast - Throughput for multi-group messages when increasing number of client"
set ylabel "Latency (us)"
set yrange [0 : 10000]
set xlabel "Throughput (kmps)" offset 1
set xrange [0 : 100]
set xtics 20
# unset xtics
set key samplen 3.5 spacing 1.2 font ",9"
set key top right


plot './data-aggregated/wbcast/tp-lat-64b.dat' index 0 using ($4/8000):14 with linespoints ls 1 title "1 group", \
     './data-aggregated/wbcast/tp-lat-64b.dat' index 1 using ($4/4000):14 with linespoints ls 2 title "2 groups", \
     './data-aggregated/wbcast/tp-lat-64b.dat' index 2 using ($4/2000):14 with linespoints ls 3 title "4 groups", \
     './data-aggregated/wbcast/tp-lat-64b.dat' index 3 using ($4/1000):14 with linespoints ls 4 title "8 groups", \


system("pstopdf ./graphs/wbcast-multi-dest-tp-vs-lat.eps -o ./graphs/wbcast-multi-dest-tp-vs-lat.eps.pdf && rm ./graphs/wbcast-multi-dest-tp-vs-lat.eps")
