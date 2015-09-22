#!/bin/bash

for dir in *bytes ; do

zkfile=${dir}/ZK.txt
smrfile=${dir}/SMR.txt
ssmrfile1p=${dir}/SSMR_1f.txt
ssmrfile2p=${dir}/SSMR_2f.txt
ssmrfile4p=${dir}/SSMR_4f.txt
ssmrfile8p=${dir}/SSMR_8f.txt

echo $dir :




###################################################
#                                                 #
#               THROUGHPUT GRAPHS                 #
#                                                 #
###################################################

tpoutput=${dir}/plot_tp.ps
echo $tpoutput

gnuplot << END_GNUPLOT

min(x,y) = (x < y ? x : y)

set terminal postscript eps enhanced mono solid lw 2 "Helvetica" 18

#xmax=6
#set xrange [0:xmax]

set output "$tpoutput"

# set bmargin 2
# set tmargin 2
# set rmargin 2
# set lmargin 2

set pointsize 1.5


# set size 0.925,0.5
# set origin 0.075,0.5
# ymax=8
# set yrange [0:*]
# set ytics 0, 2, 8
# set format y "%0.0fK"
set ylabel "Throughput (Kcps)"
set xlabel "Load (number of clients)"
# set xtics ('' 0, '' 1, '' 2, '' 3, '' 4, '' 5, '' 6)
set xrange [0 : 2000]
set yrange [0 : *]
set grid
set key bottom right
# set key samplen 2.5
#set key spacing 1.5
# set key width -3
plot "$zkfile"  using 1:(\$3 / 1e3)	title "Zookeeper" with lines lw 3,\
     "$smrfile" using 1:(\$3 / 1e3)	title "ZKsmr" with linespoints lt 5,\
     "$ssmrfile1p" using 1:(\$3 / 1e3)	title "ZKssmr 1P" with linespoints lt 6,\
     "$ssmrfile2p" using 1:(\$3 / 1e3)	title "ZKssmr 2P" with linespoints lt 7,\
     "$ssmrfile4p" using 1:(\$3 / 1e3)	title "ZKssmr 4P" with linespoints lt 8,\
     "$ssmrfile8p" using 1:(\$3 / 1e3)	title "ZKssmr 8P" with linespoints lt 9
     
END_GNUPLOT




###################################################
#                                                 #
#                  LATENCY GRAPHS                 #
#                                                 #
###################################################

latoutput=${dir}/plot_lat.ps
echo $latoutput

gnuplot << END_GNUPLOT

min(x,y) = (x < y ? x : y)

set terminal postscript eps enhanced mono solid lw 2 "Helvetica" 18

set output "$latoutput"

set pointsize 1.5

set ylabel "Latency (milliseconds)"
set xlabel "Load (number of clients)"
set yrange [0 : *]
set grid
set key top left
# set key samplen 2.5
#set key spacing 1.5
# set key width -3
plot "$zkfile"  using 1:4	title "Zookeeper" with lines lw 3,\
     "$smrfile" using 1:4	title "ZKsmr" with linespoints lt 5,\
     "$ssmrfile1p" using 1:4	title "ZKssmr 1p" with linespoints lt 6,\
     "$ssmrfile2p" using 1:4	title "ZKssmr 2p" with linespoints lt 7,\
     "$ssmrfile4p" using 1:4	title "ZKssmr 4p" with linespoints lt 8,\
     "$ssmrfile8p" using 1:4	title "ZKssmr 8p" with linespoints lt 9,\
     
END_GNUPLOT




###################################################
#                                                 #
#                    CPU GRAPHS                   #
#                                                 #
###################################################

cpuoutput=${dir}/plot_cpu.ps
echo $cpuoutput

gnuplot << END_GNUPLOT

min(x,y) = (x < y ? x : y)

set terminal postscript eps enhanced mono solid lw 2 "Helvetica" 18

set output "$cpuoutput"

set pointsize 1.5

set ylabel "CPU Load (%)"
set xlabel "Load (number of clients)"
set yrange [0:800]
set ytics 100
set grid
set key top left
# set key samplen 2.5
#set key spacing 1.5
# set key width -3
plot "$zkfile"     using 1:(8 * \$7) title "zookeeper" with lines lw 3,\
     "$smrfile"    using 1:(8 * \$7) title "zkSMR"     with linespoints lt 5,\
     "$ssmrfile1p" using 1:(8 * \$7) title "ZKssmr 1p" with linespoints lt 6,\
     "$ssmrfile2p" using 1:(8 * \$7) title "ZKssmr 2p" with linespoints lt 7,\
     "$ssmrfile4p" using 1:(8 * \$7) title "ZKssmr 4p" with linespoints lt 8,\
     "$ssmrfile8p" using 1:(8 * \$7) title "ZKssmr 8p" with linespoints lt 9

END_GNUPLOT




###################################################
#                                                 #
#                BANDWIDTH GRAPHS                 #
#                                                 #
###################################################

bwoutput=${dir}/plot_bw.ps
echo $bwoutput

gnuplot << END_GNUPLOT

min(x,y) = (x < y ? x : y)

set terminal postscript eps enhanced mono solid lw 2 "Helvetica" 18

set output "$bwoutput"

set pointsize 1.5

set ylabel "Traffic (Megabits/s)"
set yrange [0 : *]
set ytics 25
set xlabel "Load (number of clients)"
set grid
set key bottom right
# set key samplen 2.5
#set key spacing 1.5
# set key width -3
plot "$zkfile"     using 1:(\$5 * 8 / 1e6) title "Zookeeper (down)" with lines       lw 3,\
     "$smrfile"    using 1:(\$5 * 8 / 1e6) title "ZKsmr (down)"     with linespoints,\
     "$ssmrfile1p" using 1:(\$5 * 8 / 1e6) title "ZKssmr 1p (down)" with linespoints,\
     "$ssmrfile2p" using 1:(\$5 * 8 / 1e6) title "ZKssmr 2p (down)" with linespoints,\
     "$ssmrfile4p" using 1:(\$5 * 8 / 1e6) title "ZKssmr 4p (down)" with linespoints,\
     "$ssmrfile8p" using 1:(\$5 * 8 / 1e6) title "ZKssmr 8p (down)" with linespoints,\
     "$zkfile"     using 1:(\$6 * 8 / 1e6) title "Zookeeper (up)"   with linespoints,\
     "$smrfile"    using 1:(\$6 * 8 / 1e6) title "ZKsmr (up)"       with linespoints,\
     "$ssmrfile1p" using 1:(\$6 * 8 / 1e6) title "ZKssmr 1p (up)"   with linespoints,\
     "$ssmrfile2p" using 1:(\$6 * 8 / 1e6) title "ZKssmr 2p (up)"   with linespoints,\
     "$ssmrfile4p" using 1:(\$6 * 8 / 1e6) title "ZKssmr 4p (up)"   with linespoints,\
     "$ssmrfile8p" using 1:(\$6 * 8 / 1e6) title "ZKssmr 8p (up)"   with linespoints

END_GNUPLOT




###################################################
#                                                 #
#              DISK ACTIVITY GRAPHS               #
#                                                 #
###################################################

diskouttps=${dir}/plot_disk_tps.ps
diskoutmbps=${dir}/plot_disk_mbps.ps
echo $diskouttps
echo $diskoutmbps

gnuplot << END_GNUPLOT

min(x,y) = (x < y ? x : y)

set terminal postscript eps enhanced mono solid lw 2 "Helvetica" 18

set output "$diskouttps"

set pointsize 1.5

set ylabel "Disk (transfers/s)"
set yrange [0:*]
# set ytics 25
set xlabel "Load (number of clients)"
set grid
set key bottom right
# set key samplen 2.5
#set key spacing 1.5
# set key width -3
plot "$zkfile"  using 1:8 title "Zookeeper" with lines lw 3,\
     "$smrfile" using 1:8 title "ZSsmr"     with linespoints lt 5,\
     "$ssmrfile1p" using 1:8 title "ZKssmr 1p"  with linespoints lt 6,\
     "$ssmrfile2p" using 1:8 title "ZKssmr 2p"  with linespoints lt 7,\
     "$ssmrfile4p" using 1:8 title "ZKssmr 4p"  with linespoints lt 8,\
     "$ssmrfile8p" using 1:8 title "ZKssmr 8p"  with linespoints lt 9,\
     
set output "$diskoutmbps"

set ylabel "Disk (Megabytes/s)"
set xlabel "Load (number of clients)"
set grid
set key bottom right

plot "$zkfile"     using 1:(\$9  / 2048) title "Zookeeper (read)"  with linespoints lt 7,\
     "$smrfile"    using 1:(\$9  / 2048) title "ZKsmr (read)"      with linespoints lt 3,\
     "$ssmrfile1p" using 1:(\$9  / 2048) title "ZKssmr 1p (read)"  with linespoints lt 6,\
     "$ssmrfile2p" using 1:(\$9  / 2048) title "ZKssmr 2p (read)"  with linespoints lt 7,\
     "$ssmrfile4p" using 1:(\$9  / 2048) title "ZKssmr 4p (read)"  with linespoints lt 8,\
     "$ssmrfile8p" using 1:(\$9  / 2048) title "ZKssmr 8p (read)"  with linespoints lt 9,\
     "$zkfile"     using 1:(\$10 / 2048) title "Zookeeper (write)" with lines lw 3,\
     "$smrfile"    using 1:(\$10 / 2048) title "ZKsmr (write)"     with linespoints lt 5,\
     "$ssmrfile1p" using 1:(\$10 / 2048) title "ZKssmr 1p (write)" with linespoints lt 6,\
     "$ssmrfile2p" using 1:(\$10 / 2048) title "ZKssmr 2p (write)" with linespoints lt 7,\
     "$ssmrfile4p" using 1:(\$10 / 2048) title "ZKssmr 4p (write)" with linespoints lt 8,\
     "$ssmrfile8p" using 1:(\$10 / 2048) title "ZKssmr 8p (write)" with linespoints lt 9,\
     
END_GNUPLOT




for graphfile in $tpoutput $latoutput $cpuoutput $bwoutput $diskouttps $diskoutmbps
do
    pstopdf $graphfile ; rm $graphfile
done

done


for size in 100 1000 10000
do

###################################################
#                                                 #
#                READRATE GRAPHS                  #
#                                                 #
###################################################

rrzkfile=read_rates_zk_${size}bytes.txt
rrsmrfile=read_rates_smr_${size}bytes.txt
rrfile=read_rates_${size}bytes.txt
rroutput=plot_rates_${size}bytes.ps
echo $rroutput

gnuplot << END_GNUPLOT

min(x,y) = (x < y ? x : y)

set terminal postscript eps enhanced mono solid lw 2 "Helvetica" 18

set output "$rroutput"

set style data histogram
set style histogram cluster gap 1

set style fill solid border rgb "black"
set auto x

set ylabel "Throughput (Kcps)"
set yrange [0 : *]
# set ytics 5
set auto x
set xlabel "Read rate (over total)"
# set xrange [ -0.25 : 1.25 ]
# set xtics ('0.00' 0.0, '0.25' 0.25, '0.50' 0.5, '0.75' 0.75, '1.00' 1.0)
set grid ytics
set key top left
# set key samplen 2.5
#set key spacing 1.5
# set key width -3
plot "$rrfile"  using (\$3 / 1e3):xtic(1)	title "zookeeper" fs pattern 1 ,\
     ''         using (\$12 / 1e3):xtic(1)	title "zkSMR"

END_GNUPLOT

pstopdf $rroutput ; rm $rroutput

done


for rate in 0.0
do

###################################################
#                                                 #
#                   SIZE GRAPHS                   #
#                                                 #
###################################################

sizefile=sizes_${rate}readrate.txt
tpsizeoutput=plot_tp_sizes_${rate}readrate.ps
latsizeoutput=plot_lat_sizes_${rate}readrate.ps
echo $tpsizeoutput
echo $latsizeoutput

gnuplot << END_GNUPLOT

min(x,y) = (x < y ? x : y)

set terminal postscript eps enhanced color solid lw 2 "Helvetica" 18

set output "$tpsizeoutput"

set style data histogram
set style histogram cluster gap 1

set style fill solid border rgb "black"
set auto x

set ylabel "Normalized throughput"
#set yrange [0 : 70]
set ytics 1
set auto x


# THROUGHPUT x SIZE

set xlabel "Message size (bytes)"
# set xrange [ -0.25 : 1.25 ]
# set xtics ('0.00' 0.0, '0.25' 0.25, '0.50' 0.5, '0.75' 0.75, '1.00' 1.0)
set grid ytics
set key top left
# set key samplen 2.5
#set key spacing 1.5
# set key width -3
plot "$sizefile" using (\$3  / \$21):xtic(1)	title "Zookeeper" fs pattern 1 lc rgb "black",\
     ''          using (\$12 / \$21):xtic(1)	title "ZKsmr"     fs solid lc rgb "#FFFFFF",\
     ''          using (\$21 / \$21):xtic(1)	title "ZKssmr 1p"  fs solid lc rgb "#CCCCCC",\
     ''          using (\$30 / \$21):xtic(1)	title "ZKssmr 2p"  fs solid lc rgb "#999999",\
     ''          using (\$39 / \$21):xtic(1)	title "ZKssmr 4p"  fs solid lc rgb "#666666",\
     ''          using (\$48 / \$21):xtic(1)	title "ZKssmr 8p"  fs solid lc rgb "#333333"


# THROUGHPUT x SIZE

set output "$latsizeoutput"
set ylabel "Latency (ms)"
set auto x
set auto y
set xtics auto
set ytics auto
plot "$sizefile" using (\$4 ):xtic(1)	title "Zookeeper" fs pattern 1 lc rgb "black",\
     ''          using (\$13):xtic(1)	title "ZKsmr"     fs solid lc rgb "#FFFFFF",\
     ''          using (\$22):xtic(1)	title "ZKssmr 1p"  fs solid lc rgb "#CCCCCC",\
     ''          using (\$31):xtic(1)	title "ZKssmr 2p"  fs solid lc rgb "#999999",\
     ''          using (\$40):xtic(1)	title "ZKssmr 4p"  fs solid lc rgb "#666666",\
     ''          using (\$49):xtic(1)	title "ZKssmr 8p"  fs solid lc rgb "#333333"


     
END_GNUPLOT

pstopdf $tpsizeoutput  ; rm $tpsizeoutput
pstopdf $latsizeoutput ; rm $latsizeoutput
done






for size in 100 1000 10000
do

###################################################
#                                                 #
#               LATENCY CDF GRAPHS                #
#                                                 #
###################################################
dir=0.0readrate_${size}bytes
zkcdffile=${dir}/ZK_LatCdf.txt
smrcdffile=${dir}/SMR_LatCdf.txt
ssmr1pcdffile=${dir}/SSMR_1p_LatCdf.txt
ssmr2pcdffile=${dir}/SSMR_2p_LatCdf.txt
ssmr4pcdffile=${dir}/SSMR_4p_LatCdf.txt
ssmr8pcdffile=${dir}/SSMR_8p_LatCdf.txt
cdfoutput=${dir}/plot_latency_cdfs_${size}bytes.ps
echo $cdfoutput

gnuplot << END_GNUPLOT

min(x,y) = (x < y ? x : y)

set terminal postscript eps enhanced color solid lw 2 "Helvetica" 18

set termoption dash

set output "$cdfoutput"
set auto x

set ylabel "Cumulative distribution function"
set yrange [0 : 1]

set xlabel "Latency (ms)"

set grid ytics

set key bottom right

plot "$zkcdffile"     using (\$1 / 1e6):(\$2 / 1e3)	title "Zookeeper" with lines lc rgb "#000000" lw 1.75,\
     "$smrcdffile"    using (\$1 / 1e6):(\$2 / 1e3)	title "ZKsmr"     with lines lc rgb "#008B8B" lw 1.75,\
     "$ssmr1pcdffile" using (\$1 / 1e6):(\$2 / 1e3)	title "ZKssmr 1P"  with lines lc rgb "#FF0000" lw 1.75,\
     "$ssmr2pcdffile" using (\$1 / 1e6):(\$2 / 1e3)	title "ZKssmr 2P"  with lines lc rgb "#008000" lw 1.75,\
     "$ssmr4pcdffile" using (\$1 / 1e6):(\$2 / 1e3)	title "ZKssmr 4P"  with lines lc rgb "#0000FF" lw 1.75,\
     "$ssmr8pcdffile" using (\$1 / 1e6):(\$2 / 1e3)	title "ZKssmr 8P"  with lines lc rgb "#333333" lw 1.75

END_GNUPLOT

pstopdf $cdfoutput ; rm $cdfoutput

done