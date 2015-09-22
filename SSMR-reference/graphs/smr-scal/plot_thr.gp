set terminal postscript eps enhanced lw 2 "Helvetica" 24
set output "scale.eps"

set xlabel "Number of replicas (N)"
set ylabel "Normalized throughput"

set xrange [ 0 : 10]  
set yrange [ 0:10] 

set xtics 2
#set ytics 200000 
#set ytics ("0" 0, "200K" 200000, "400K" 400000, "600K" 600000, "800K" 800000)
#set xtics ("0" 0, "5" 5, "10" 10, "15" 15, "20" 20, "100" 100)

#set grid noxtics ytics
set grid xtics ytics

set key inside top left
#set nokey

plot  	"data.txt"    using 1:5 with lines  lt 1 lw 5 title "Ideally Scalable SMR",\
	"data.txt"    using 1:4 with lines  lt 2 lw 5 title "Read-only optimisation",\
	"data.txt"    using 1:3 with lines  lt 3 lw 5 title "Update optimisation",\
	"data.txt"    using 1:2 with lines  lt 4 lw 5 title "Classical SMR"

#plot  	"data.txt"    using 1:2 with linespoint  lt 1 lw 1 ps 2 pt 4 title "Classical SMR",\
#	"data.txt"    using 1:3 with linespoint  lt 2 lw 1 ps 2 pt 3 title "Update optimisation",\
#	"data.txt"    using 1:4 with linespoint  lt 3 lw 1 ps 2 pt 1 title "Read-only optimisation",\
#	"data.txt"    using 1:5 with linespoint  lt 4 lw 1 ps 2 pt 2 title "Scalable SMR"


!epstopdf scale.eps && rm scale.eps
