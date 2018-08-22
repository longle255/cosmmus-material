set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 22
set output './social-network-dynamic-structure.ps'
set size 1,0.7
set grid ytics
set auto y

set key top left
set style line 1 lc rgb '#0060ad' lt 1 lw 1 pt 5 pi 15 ps 1
set style line 2 lc rgb '#000000' lt 1 lw 1 pt 4 pi 15 ps 1

set xlabel "Time(s)"
set xrange [0:250]
set xtics 0,50,250

set yrange [0:1000]
set ytics 0,200,1000

#set y2label "Vertices" offset 1.5

#set y2label "Edges" offset 1.5
#set y2range [0:500000]
#set y2tics 0,100000,500000

plot 'social-network-dynamic-structure.dat' using 2 with linespoints ls 1 title "Number of users (thousand)",\
     '' using 3 with linespoints ls 2 title "Number of connections (thousand)"

#'' using 3 with line lt 2 lw 0.5 lc black title col axes x1y2
