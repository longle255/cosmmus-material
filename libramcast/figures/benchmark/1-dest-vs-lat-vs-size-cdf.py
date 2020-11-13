import Gnuplot
import Gnuplot.funcutils


def plot(graph_name, data, output, xrange):
    g = Gnuplot.Gnuplot(debug=0, )
    g('set terminal postscript eps enhanced color solid lw 2 "Times-Roman" 16')
    g('set size 0.7,0.5')
    g('set grid ytics')
    g('set grid xtics')
    g('set output "' + output + '"')
    g('set style data lines')  # give gnuplot an arbitrary command
    g('set style func linespoints')

    g('set title "Latency CDF with single destination when increasing package size"')
    g('set xrange ' + xrange)
    g('set xtics 40')
    g('set ytics 0.2 ')
    g('set key samplen 3.5 spacing 1.2 font ",9"')
    g('set key center right')
    g('set xlabel "Latency(us)"')

    # ps: point size
    g("set style line 1 lt 1 lw 0.8 pt 1 ps 0.5 pointinterval 30")
    g("set style line 2 lt 2 lw 0.8 pt 2 ps 0.5 pointinterval 30")
    g("set style line 3 lt 3 lw 0.8 pt 3 ps 0.5 pointinterval 30")
    g("set style line 4 lt 4 lw 0.8 pt 4 ps 0.5 pointinterval 30")
    g("set style line 5 lt 5 lw 0.8 pt 5 ps 0.5 pointinterval 30")
    g("set style line 6 lt 6 lw 0.8 pt 6 ps 0.5 pointinterval 30")
    g("set style line 7 lt 7 lw 0.8 pt 7 ps 0.5 pointinterval 30")

    g.plot(
        Gnuplot.Data(data[0], using="2:1", with_="linespoints ls 1", title="64B"),
        Gnuplot.Data(data[1], using="2:1", with_="linespoints ls 2", title="512B"),
        Gnuplot.Data(data[2], using="2:1", with_="linespoints ls 3", title="1KB"),
        Gnuplot.Data(data[3], using="2:1", with_="linespoints ls 4", title="2KB"),
        Gnuplot.Data(data[4], using="2:1", with_="linespoints ls 5", title="16KB"),
        Gnuplot.Data(data[5], using="2:1", with_="linespoints ls 6", title="32KB"),
        Gnuplot.Data(data[6], using="2:1", with_="linespoints ls 7", title="64KB"))

    g.reset()


def collect_lat(file):
    ret = []
    f = open(file)
    reduce_factor = 1
    for line in f:
        if line.startswith('#'):
            if "(ns)" in line:
                reduce_factor = 1000
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


# DATA = '/Users/longle/Documents/Workspace/PhD/ScalableSMR/plotting/libRamcastV3/data/selected/max-single-dest-1-group-1-vary-size-rerun'
# data = []
# data.append(
#     collect_lat(DATA + '/1d-8g-6c-3p-98b-2020-11-12-04-39-31/latencydistribution_client_overall_aggregate.log'))
# data.append(
#     collect_lat(DATA + '/1d-8g-6c-3p-512b-2020-11-12-04-48-31/latencydistribution_client_overall_aggregate.log'))
# data.append(
#     collect_lat(DATA + '/1d-8g-6c-3p-1024b-2020-11-12-04-57-32/latencydistribution_client_overall_aggregate.log'))
# data.append(
#     collect_lat(DATA + '/1d-8g-6c-3p-2048b-2020-11-12-05-06-33/latencydistribution_client_overall_aggregate.log'))
# data.append(
#     collect_lat(DATA + '/1d-8g-6c-3p-16384b-2020-11-12-05-15-34/latencydistribution_client_overall_aggregate.log'))
# data.append(
#     collect_lat(DATA + '/1d-8g-6c-3p-32768b-2020-11-12-05-24-36/latencydistribution_client_overall_aggregate.log'))
# data.append(
#     collect_lat(DATA + '/1d-8g-6c-3p-65536b-2020-11-12-05-33-37/latencydistribution_client_overall_aggregate.log'))

# ==============================================================================================================================

DATA = '/Users/longle/Documents/Workspace/PhD/ScalableSMR/plotting/libRamcastV3/data/selected/max-single-dest-1-group-1-vary-size-r320'
data = []
data.append(
    collect_lat(DATA + '/1d-5g-6c-3p-98b-2020-11-13-02-30-38/latencydistribution_client_overall_aggregate.log'))
data.append(
    collect_lat(DATA + '/1d-5g-6c-3p-512b-2020-11-13-02-42-23/latencydistribution_client_overall_aggregate.log'))
data.append(
    collect_lat(DATA + '/1d-5g-6c-3p-1024b-2020-11-13-02-52-32/latencydistribution_client_overall_aggregate.log'))
data.append(
    collect_lat(DATA + '/1d-5g-6c-3p-2048b-2020-11-13-03-02-42/latencydistribution_client_overall_aggregate.log'))
data.append(
    collect_lat(DATA + '/1d-5g-5c-3p-16384b-2020-11-13-03-11-43/latencydistribution_client_overall_aggregate.log'))
data.append(
    collect_lat(DATA + '/1d-5g-4c-3p-32768b-2020-11-13-03-20-45/latencydistribution_client_overall_aggregate.log'))
data.append(
    collect_lat(DATA + '/1d-5g-4c-3p-65536b-2020-11-13-03-30-55/latencydistribution_client_overall_aggregate.log'))

graph_file = "./graphs/1-dest-vs-lat-vs-size-cdf.eps"
plot("Latency CDF", data, graph_file, '[0:500]')

print(graph_file + " saved")
