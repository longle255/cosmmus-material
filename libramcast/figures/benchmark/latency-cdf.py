import Gnuplot
import Gnuplot.funcutils


def plot(graph_name, data, output, xrange, xtick, title):
  g = Gnuplot.Gnuplot(debug=0, )
  g('set terminal postscript eps enhanced color solid lw 2 "Times-Roman" 16')
  g('set size 0.7,0.5')
  g('set grid ytics')
  g('set grid xtics')
  g('set output "' + output + '"')

  g('set style data lines')  # give gnuplot an arbitrary command
  g('set style func linespoints')

  g('set title "{}"'.format(title))
  g('set xrange ' + xrange)
  g('set xtics ' + str(xtick))
  g('set ytics 0.2 ')
  g('set key center right')
  g('set xlabel "Latency ({/symbol u}s)"')

  g("set style line 1 lt 1 lw 0.8 pt 1 ps 0.5 pointinterval 30")
  g("set style line 2 lt 2 lw 0.8 pt 2 ps 0.5 pointinterval 30")
  g("set style line 3 lt 3 lw 0.8 pt 3 ps 0.5 pointinterval 30")
  g("set style line 4 lt 4 lw 0.8 pt 4 ps 0.5 pointinterval 30")

  g.plot(Gnuplot.Data(data[0], using="2:1", with_="linespoints ls 1", title="1 groups"),
         Gnuplot.Data(data[1], using="2:1", with_="linespoints ls 2", title="2 groups"),
         Gnuplot.Data(data[2], using="2:1", with_="linespoints ls 3", title="4 groups"),
         Gnuplot.Data(data[3], using="2:1", with_="linespoints ls 4", title="8 groups"))

  g.reset()


def collect_lat(file):
  ret = []
  f = open(file)
  for line in f:
    if line.startswith('#'):
      continue
    tmp = [int(field) for field in line.strip().split()]
    i = 1
    while i < len(tmp):
      ret.append([tmp[i + 1], float(tmp[i]) / 1000])
      i += 2
  f.close()
  sum = ret[len(ret) - 1][0]

  for rec in ret:
    rec[0] = float(rec[0]) / sum
  return ret


DATA = '/Users/longle/Documents/Workspace/PhD/ScalableSMR/plotting/libRamcastV3/data/selected/multi-dest-1248-partition'
data = []
data.append(collect_lat(DATA + '/1d-6c-3p-360b-2020-11-12-08-37-31/latencydistribution_client_overall_aggregate.log'))
data.append(collect_lat(DATA + '/2d-6c-3p-360b-2020-11-12-08-06-45/latencydistribution_client_overall_aggregate.log'))
data.append(collect_lat(DATA + '/4d-6c-3p-360b-2020-11-12-08-16-54/latencydistribution_client_overall_aggregate.log'))
data.append(collect_lat(DATA + '/8d-6c-3p-360b-2020-11-12-08-27-03/latencydistribution_client_overall_aggregate.log'))

graph_file = "./graphs/multi-dest-lat-cdf.eps"
plot("Latency CDF", data, graph_file, '[0:250]', 50, "Latency CDF for multi-group messages at maximum load")

DATA = '/Users/longle/Documents/Workspace/PhD/ScalableSMR/plotting/libRamcastV3/data/selected/multi-dest-1248-partition-single-client'
data = []
data.append(collect_lat(DATA + '/1d-1c-3p-98b-2020-11-08-10-37-47/latencydistribution_client_overall_aggregate.log'))
data.append(collect_lat(DATA + '/2d-1c-3p-192b-2020-11-08-11-47-19/latencydistribution_client_overall_aggregate.log'))
data.append(collect_lat(DATA + '/4d-1c-3p-256b-2020-11-08-12-20-50/latencydistribution_client_overall_aggregate.log'))
data.append(collect_lat(DATA + '/8d-1c-3p-360b-2020-11-08-12-46-05/latencydistribution_client_overall_aggregate.log'))

graph_file = "./graphs/multi-dest-single-client-lat-cdf.eps"

plot("Latency CDF", data, graph_file, '[0:120]', 30, "Latency CDF for multi-group messages with single client")

DATA = '/Users/longle/Documents/Workspace/PhD/ScalableSMR/plotting/libRamcastV3/data/selected/sing-dest-1248-partition'

data = []
data.append(collect_lat(DATA + '/1d-6c-3p-98b-2020-11-08-04-47-31/latencydistribution_client_overall_aggregate.log'))
data.append(collect_lat(DATA + '/2d-6c-3p-98b-2020-11-08-08-56-00/latencydistribution_client_overall_aggregate.log'))
data.append(collect_lat(DATA + '/4d-6c-3p-98b-2020-11-08-06-02-50/latencydistribution_client_overall_aggregate.log'))
data.append(collect_lat(DATA + '/8d-6c-3p-98b-2020-11-08-07-06-42/latencydistribution_client_overall_aggregate.log'))

graph_file = "./graphs/single-dest-lat-cdf.eps"
plot("Latency CDF", data, graph_file, '[0:50]', 10, "Latency CDF for single-group messages at maximum load")

print(graph_file + " saved")
