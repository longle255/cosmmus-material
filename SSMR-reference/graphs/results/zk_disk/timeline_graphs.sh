#!/bin/bash

latrange=30

strdev=$1


if [ "$strdev" == "memory" ]
then
   latrange=30
elif [ "$strdev" == "disk" ]
then
   latrange=80
fi

data100="timelines_100.txt"
data1000="timelines_1000.txt"
data10000="timelines_10000.txt"
output="timelines_all.ps"

gnuplot << END_GNUPLOT

set terminal postscript eps enhanced color solid lw 2 "Helvetica" 18

set bmargin 4.3
set tmargin 2
set rmargin 2

set ylabel offset 1.8,0
set xtics offset 0,0.2
set ytics offset 0.45,0

set title "Latency components for S-SMR" offset 0,-0.5

#set key samplen 2 inside invert noopaque
set key samplen 2 inside top left maxrows 2 invert noautotitle width -3
set key autotitle columnheader

set style data histogram
set style histogram rowstacked

set style fill solid border -1
set boxwidth 0.75

#set xlabel "Message size (bytes)" offset 0, -3
set xlabel " " offset 0,-0.225
set label "Message size (bytes)" at 4.5,-4.25

set ylabel "Latency (ms)"
set grid ytics

set yrange [0:$latrange]


set output "$output"



# t_client_send
# t_batch_ready
# t_batch_serialized
# t_learner_delivered
# t_learner_deserialized
# t_command_enqueued
# t_ssmr_dequeued
# t_execution_start
# t_server_send
# t_client_receive

# format of datafile
# "100b, 1P" <tl>
# "100b, 2P"
# "100b, 4P"
# "100b, 8P"
# #
# "1kb, 1P"
# "1kb, 2P"
# "1kb, 4P"
# "1kb, 8P"
# #
# "10kb, 1P"
# "10kb, 2P"
# "10kb, 4P"
# "10kb, 8P"

plot newhistogram "100", "$data100" using (\$3  - \$2 ):xtic(1) title 'Batching' fs solid lc rgb "black",\
             '' using (\$5  - \$3 ):xtic(1) title 'Multicasting' fs solid lc rgb "#555555",\
             '' using (\$8  - \$5 ):xtic(1) title 'Waiting' fs solid lc rgb "#AAAAAA",\
             '' using (\$11 - \$8 ):xtic(1) title 'Executing' fs solid lc rgb "white",\
     newhistogram "1000", "$data1000" using (\$3  - \$2 ):xtic(1) notitle fs solid lc rgb "black",\
             '' using (\$5  - \$3 ):xtic(1) notitle fs solid lc rgb "#555555",\
             '' using (\$8  - \$5 ):xtic(1) notitle fs solid lc rgb "#AAAAAA",\
             '' using (\$11 - \$8 ):xtic(1) notitle fs solid lc rgb "white",\
     newhistogram "10000", "$data10000" using (\$3  - \$2 ):xtic(1) notitle fs solid lc rgb "black",\
             '' using (\$5  - \$3 ):xtic(1) notitle fs solid lc rgb "#555555",\
             '' using (\$8  - \$5 ):xtic(1) notitle fs solid lc rgb "#AAAAAA",\
             '' using (\$11 - \$8 ):xtic(1) notitle fs solid lc rgb "white"
             
             
             

END_GNUPLOT

pstopdf $output ; rm $output
