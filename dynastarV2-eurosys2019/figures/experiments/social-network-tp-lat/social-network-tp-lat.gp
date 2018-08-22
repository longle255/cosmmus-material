set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16
set output './social-network-tp-lat.ps'
set size 1.35,1.1
set multiplot
set grid ytics
set style data histogram
set style histogram cluster gap 1
set style fill pattern 0 border rgb "black"
set linetype 1 lc rgb "#888888" lw 1 pt 0
set linetype 2 lc rgb "#888888" lw 1 pt 0

set lmargin at screen 0.1
set rmargin 0
set bmargin 1.2
set size 0.4,0.5
set title "0% Edge-cut"
set origin 0,0.5
set ylabel "Throughput (kcps)" offset 1.5
set yrange [0 : 120]
set ytics 20
unset xtics
plot 'social-network-tp-lat-0.0-edgecut.dat' using 2 fs pattern 0 lc rgb '#888888' notitle, \
        '' using 4 fs pattern 1 lc rgb '#888888' notitle, \
        '' using 3 fs pattern 2 lc rgb '#888888' notitle


set lmargin 0
set rmargin 0
unset ylabel
set title "1% Edge-cut"
set format y ""
set origin 0.4,0.5
set size 0.3,0.5
plot 'social-network-tp-lat-0.01-edgecut.dat' using 2 fs pattern 0 lc rgb '#888888' notitle, \
        '' using 4 fs pattern 1 lc rgb '#888888' notitle, \
        '' using 3 fs pattern 2 lc rgb '#888888' notitle


set lmargin 0
set rmargin 0
set title "5% Edge-cut"
set format y ""
set origin 0.7,0.5
set size 0.3,0.5
plot 'social-network-tp-lat-0.05-edgecut.dat' using 2 fs pattern 0 lc rgb '#888888' notitle, \
        '' using 4 fs pattern 1 lc rgb '#888888' notitle, \
        '' using 3 fs pattern 2 lc rgb '#888888' notitle


set lmargin 0
unset xlabel
set title "Mix"
set bmargin 1.2
set origin 1,0.5
set size 0.3,0.5
set title "10% Edge-cut"
set key at 3,110
plot 'social-network-tp-lat-0.10-edgecut.dat' using 2 fs pattern 0 lc rgb '#888888' title 'DS-SMR', \
        '' using 4 fs pattern 1 lc rgb '#888888' title "S-SMR~ {.1*}", \
        '' using 3 fs pattern 2 lc rgb '#888888' title 'DynaStar'



#====================================================================================

set key default
unset title
set ylabel "Latency (ms)" offset 5
set style histogram errorbars gap 1 lw 1
set lmargin at screen 0.1;
set rmargin 0
set bmargin 1.2
set origin 0,0.1
set size 0.4,0.45
set ylabel "Latency (ms)" offset 0.5
unset format y
set yrange [1 : 15]
set ytics 3
# set xtics offset 0, 0
# set xrange [0 : 10]
set xtics ( "2" 2, "4" 4, "8" 8)

plot 'social-network-tp-lat-0.0-edgecut.dat' using 5:6:xtic(1) fs pattern 0 lc rgb '#888888' notitle, \
        '' using 9:10:xtic(1) fs pattern 1 lc rgb '#888888' notitle, \
        '' using 7:8:xtic(1) fs pattern 2 lc rgb '#888888' notitle

plot 'social-network-tp-lat-0.0-edgecut.dat' using 5:11 fs pattern 0 lc rgb '#888888' notitle, \
        '' using 9:11 fs pattern 1 lc rgb '#888888' notitle, \
        '' using 7:11 fs pattern 2 lc rgb '#888888' notitle

set lmargin 0
set rmargin 0
unset ylabel
set format y ""
set origin 0.4,0.1
set size 0.3,0.45
plot 'social-network-tp-lat-0.01-edgecut.dat' using 5:6:xtic(1) fs pattern 0 lc rgb '#888888' notitle, \
        '' using 9:10:xtic(1) fs pattern 1 lc rgb '#888888' notitle, \
        '' using 7:8:xtic(1) fs pattern 2 lc rgb '#888888' notitle

plot 'social-network-tp-lat-0.01-edgecut.dat' using 5:11 fs pattern 0 lc rgb '#888888' notitle, \
        '' using 9:11 fs pattern 1 lc rgb '#888888' notitle, \
        '' using 7:11 fs pattern 2 lc rgb '#888888' notitle


set lmargin 0
set rmargin 0
unset ylabel
set format y ""
set origin 0.7,0.1
set size 0.3,0.45
plot 'social-network-tp-lat-0.05-edgecut.dat' using 5:6:xtic(1) fs pattern 0 lc rgb '#888888' notitle, \
        '' using 9:10:xtic(1) fs pattern 1 lc rgb '#888888' notitle, \
        '' using 7:8:xtic(1) fs pattern 2 lc rgb '#888888' notitle

plot 'social-network-tp-lat-0.05-edgecut.dat' using 5:11 fs pattern 0 lc rgb '#888888' notitle, \
        '' using 9:11 fs pattern 1 lc rgb '#888888' notitle, \
        '' using 7:11 fs pattern 2 lc rgb '#888888' notitle


set xlabel "Number of partitions" offset -35,-0.5
set lmargin 0
set bmargin 1.2
set origin 1,0.1
set size 0.3,0.45
plot 'social-network-tp-lat-0.10-edgecut.dat' using 5:6:xtic(1) fs pattern 0 lc rgb '#888888' notitle, \
        '' using 9:10:xtic(1) fs pattern 1 lc rgb '#888888' notitle, \
        '' using 7:8:xtic(1) fs pattern 2 lc rgb '#888888' notitle

plot 'social-network-tp-lat-0.10-edgecut.dat' using 5:11 fs pattern 0 lc rgb '#888888' notitle, \
        '' using 9:11 fs pattern 1 lc rgb '#888888' notitle, \
        '' using 7:11 fs pattern 2 lc rgb '#888888' notitle
