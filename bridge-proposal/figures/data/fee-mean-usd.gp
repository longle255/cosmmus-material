set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 14
set output './transaction-fee-mean-usd.eps'
set xdata time                         
set timefmt '%d/%m/%Y'
set xrange ["01/01/2020":"02/06/2020"]
set grid ytics
set size 1,0.5
set key outside
# set xtics rotate
# f(x)=sprintf("%d-%d-%d", int(x-1)%30+1, floor((x-1)/30)+1, 2018+floor((x-1)/365))
set logscale y 10
plot 'etc_FeeMeanUSD.txt' u 1:2 w lp pointinterval 5 title 'Etherum Classic',\
     'eth_FeeMeanUSD.txt' u 1:2 w lp pointinterval 5 title 'Etherum',\
     'xlm_FeeMeanUSD.txt' u 1:2 w lp pointinterval 5 title 'Stellar',\

# plot 'eth_FeeMeanUSD.txt' u (f($1)):2 w lp ls 4 lw 3
# plot 'test' u (f($1)):2 w lp ls 4 lw 3
