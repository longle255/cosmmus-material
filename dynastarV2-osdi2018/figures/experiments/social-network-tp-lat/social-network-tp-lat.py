import os

import sys

__author__ = 'longle'

import Gnuplot
import Gnuplot.funcutils

import common


def plot_multi(graph_name, data, output, title):
    g = Gnuplot.Gnuplot(debug=0, )

    g('set terminal postscript eps enhanced color solid lw 2 "Times-Roman" 16')
    # g('set terminal jpeg ')
    g('set output "' + output + '"')
    g('set size 1.35,1.1')
    g('set multiplot')
    g('set grid ytics')
    g('set style data histogram')  # give gnuplot an arbitrary command
    g('set style histogram cluster gap 1')  # give gnuplot an arbitrary command
    # g('set style histogram errorbars gap 1 lw 1')
    g('set style fill pattern 0 border rgb "black"')
    g('set linetype 1 lc rgb "#888888" lw 1 pt 0')
    g('set linetype 2 lc rgb "#888888" lw 1 pt 0')

    ####################################################################################
    # throughput                                                                       #
    ####################################################################################
    # data = report[0]
    g("set lmargin at screen 0.1;")
    g("set rmargin 0")
    g("set bmargin 1.2")
    g('set size 0.4,0.5')
    g('set title "' + title[0])
    g('set origin 0,0.5')
    g('set ylabel "Throughput (kcps)" offset 1.5')
    g('set yrange [0 : 120]')
    g('set ytics 20')
    g('set auto x')
    g('set xtics offset 0, 0')
    g('unset xtics')

    g.plot(Gnuplot.Data(data[0]['data'], using="2:xtic(1) fs pattern 0 lc rgb '#888888'"),
           Gnuplot.Data(data[0]['data'], using="3:xtic(1) fs pattern 1 lc rgb '#888888'"),
           Gnuplot.Data(data[0]['data'], using="4:xtic(1) fs pattern 3 lc rgb '#888888'"),
           )

    g("set lmargin 0")
    g("set rmargin 0")
    g('unset ylabel')
    g('set title "' + title[1])
    g('set format y ""')
    g('set origin 0.4,0.5')
    g('set size 0.3,0.5')

    g.plot(Gnuplot.Data(data[1]['data'], using="2:xtic(1) fs pattern 0 lc rgb '#888888'"),
           Gnuplot.Data(data[1]['data'], using="3:xtic(1) fs pattern 1 lc rgb '#888888'"),
           Gnuplot.Data(data[1]['data'], using="4:xtic(1) fs pattern 3 lc rgb '#888888'"),
           )

    g("set lmargin 0")
    g("set rmargin 0")
    g('unset ylabel')
    g('set title "' + title[2])
    g('set format y ""')
    g('set origin 0.7,0.5')
    g('set size 0.3,0.5')
    # g('set xlabel "Number of partitions" offset 0,-0.5')

    g.plot(Gnuplot.Data(data[2]['data'], using="2:xtic(1) fs pattern 0 lc rgb '#888888'"),
           Gnuplot.Data(data[2]['data'], using="3:xtic(1) fs pattern 1 lc rgb '#888888'"),
           Gnuplot.Data(data[2]['data'], using="4:xtic(1) fs pattern 3 lc rgb '#888888'"),
           )

    g("set lmargin 0")
    g('unset xlabel')
    g('set title "Mix"')
    g("set bmargin 1.2")
    g('set origin 1,0.5')
    g('set size 0.3,0.5')
    g('set title "' + title[3])
    g('set key at 3,110')
    g.plot(Gnuplot.Data(data[3]['data'], using="2:xtic(1) fs pattern 0 lc rgb '#888888'", title='DS-SMR'),
           Gnuplot.Data(data[3]['data'], using="3:xtic(1) fs pattern 1 lc rgb '#888888'", title='DynaStar'),
           Gnuplot.Data(data[3]['data'], using="4:xtic(1) fs pattern 3 lc rgb '#888888'", title='S-SMR~ {.1*}'),
           )
    # g.plot(Gnuplot.Data(data[3]['data'], using="1 fs pattern 0 lc rgb '#888888'", title='DYNASTAR'),
    #        Gnuplot.Data(data[3]['data'], using="2:xtic(1) fs pattern 1 lc rgb '#888888'", title='S-SMR~ {.1*}'),
    #        Gnuplot.Data(data[3]['data'], using="3:xtic(1) fs pattern 3 lc rgb '#888888'", title='S-SMR~ {.1*}'),
    #        )

    # ####################################################################################
    # # latency                                                                       #
    # ####################################################################################

    g('set key default')
    g('unset title')
    g('set ylabel "Latency (ms)" offset 5')
    g('set style histogram errorbars gap 1 lw 1')
    g("set lmargin at screen 0.1;")
    g("set rmargin 0")
    g("set bmargin 1.2")
    g('set origin 0,0.1')
    g('set size 0.4,0.45')
    g('set ylabel "Latency (ms)" offset 2.5')
    g('unset format y')
    g('set yrange [1 : 15]')
    g('set ytics 3')
    g('set auto x')
    g('set xtics offset 0, 0')

    g.plot(Gnuplot.Data(data[4]['data'], using="2:3 fs pattern 0 lc rgb '#888888'"),
           Gnuplot.Data(data[4]['data'], using="4:5:xtic(1) fs pattern 1 lc rgb '#888888'"),
           Gnuplot.Data(data[4]['data'], using="6:7:xtic(1) fs pattern 3 lc rgb '#888888'"),
           )
    g.plot(Gnuplot.Data(data[4]['data'], using="2:8 fs pattern 0 lc rgb '#888888'"),
           Gnuplot.Data(data[4]['data'], using="4:8:xtic(1) fs pattern 1 lc rgb '#888888'"),
           Gnuplot.Data(data[4]['data'], using="6:8:xtic(1) fs pattern 3 lc rgb '#888888'"),
           )

    g("set lmargin 0")
    g("set rmargin 0")
    g('unset ylabel')
    g('set format y ""')
    g('set origin 0.4,0.1')
    g('set size 0.3,0.45')

    g.plot(Gnuplot.Data(data[5]['data'], using="2:3 fs pattern 0 lc rgb '#888888'"),
           Gnuplot.Data(data[5]['data'], using="4:5:xtic(1) fs pattern 1 lc rgb '#888888'"),
           Gnuplot.Data(data[5]['data'], using="6:7:xtic(1) fs pattern 3 lc rgb '#888888'"),
           )
    g.plot(Gnuplot.Data(data[5]['data'], using="2:8 fs pattern 0 lc rgb '#888888'"),
           Gnuplot.Data(data[5]['data'], using="4:8:xtic(1) fs pattern 1 lc rgb '#888888'"),
           Gnuplot.Data(data[5]['data'], using="6:8:xtic(1) fs pattern 3 lc rgb '#888888'"),
           )

    g("set lmargin 0")
    g("set rmargin 0")
    g('unset ylabel')
    g('set format y ""')
    g('set origin 0.7,0.1')
    g('set size 0.3,0.45')
    g('set xlabel "Number of partitions" offset -12,-0.5')

    g.plot(Gnuplot.Data(data[6]['data'], using="2:3 fs pattern 0 lc rgb '#888888'"),
           Gnuplot.Data(data[6]['data'], using="4:5:xtic(1) fs pattern 1 lc rgb '#888888'"),
           Gnuplot.Data(data[6]['data'], using="6:7:xtic(1) fs pattern 3 lc rgb '#888888'"),
           )
    g.plot(Gnuplot.Data(data[6]['data'], using="2:8 fs pattern 0 lc rgb '#888888'"),
           Gnuplot.Data(data[6]['data'], using="4:8:xtic(1) fs pattern 1 lc rgb '#888888'"),
           Gnuplot.Data(data[6]['data'], using="6:8:xtic(1) fs pattern 3 lc rgb '#888888'"),
           )

    g("set lmargin 0")
    g('unset xlabel')
    g("set bmargin 1.2")
    g('set origin 1,0.1')
    g('set size 0.3,0.45')

    g.plot(Gnuplot.Data(data[7]['data'], using="2:3 fs pattern 0 lc rgb '#888888'"),
           Gnuplot.Data(data[7]['data'], using="4:5:xtic(1) fs pattern 1 lc rgb '#888888'"),
           Gnuplot.Data(data[7]['data'], using="6:7:xtic(1) fs pattern 3 lc rgb '#888888'"),
           )
    g.plot(Gnuplot.Data(data[7]['data'], using="2:8 fs pattern 0 lc rgb '#888888'"),
           Gnuplot.Data(data[7]['data'], using="4:8:xtic(1) fs pattern 1 lc rgb '#888888'"),
           Gnuplot.Data(data[7]['data'], using="6:8:xtic(1) fs pattern 3 lc rgb '#888888'"),
           )


def fix_partitioning(graph_file):
    f = open(graph_file, 'r')
    filedata = f.read()
    f.close()

    newdata = filedata.replace("[ [(Times-Roman) 160.0 0.0 true true 0 (1.0)]",
                               "[ [(Times-Roman) 160.0 0.0 true true 0 (1)]")
    newdata = newdata.replace("[ [(Times-Roman) 160.0 0.0 true true 0 (2.0)]",
                              "[ [(Times-Roman) 160.0 0.0 true true 0 (2)]")
    newdata = newdata.replace("[ [(Times-Roman) 160.0 0.0 true true 0 (4.0)]",
                              "[ [(Times-Roman) 160.0 0.0 true true 0 (4)]")
    newdata = newdata.replace("[ [(Times-Roman) 160.0 0.0 true true 0 (8.0)]",
                              "[ [(Times-Roman) 160.0 0.0 true true 0 (8)]")

    f = open(graph_file, 'w')
    f.write(newdata)
    f.close()


def collect_peak_tp(folder):
    tps = []
    gap = 1000
    min_start = sys.maxint
    min_end = sys.maxint
    peak = 0
    avg = 0
    trim = 20
    NODES = range(10001, 10099)
    prefix = 'throughput_client_overall_'
    if 'DSSMR' in folder:
        NODES = range(15, 98)
        prefix = 'throughput_client_conservative_overall_'
    for client in NODES:
        tp_file = folder + prefix + str(client) + '.log'
        if not os.path.isfile(tp_file):
            continue
        f = open(tp_file)
        reduce_factor = 1
        records = []
        start = None
        end = None
        for line in f:
            if line.startswith('#'):
                if "(ns)" in line:
                    reduce_factor = 1000000
                elif "(cps)" in line:
                    reduce_factor = 1000
                continue
            tmp = [float(field) for field in line.strip().split()]
            if start == None: start = tmp[0]
            end = tmp[0]
            records.append([tmp[0], (tmp[2] / reduce_factor)])
        f.close()

        if min_start > start: min_start = start
        if min_end > end: min_end = end
        tps.append(records)
    ret = []
    t = min_start
    while t < min_end:
        sum = 0
        for records in tps:
            for record in records:
                if (record[0] <= t + gap):
                    sum += record[1]
                    records.remove(record)
                else:
                    break
        ret.append([(t - min_start) / 1000, sum])
        t += gap
    for rec in ret:
        if rec[1] > peak: peak = rec[1]
    sum = 0
    for rec in ret[trim:]:
        sum += rec[1]
    avg = float(sum) / (len(ret) - trim)
    return {
        'full': ret,
        'peak': peak,
        'avg': avg
    }


# ROOT = '../../experimentData/socc-selected/tp/'
ROOT = '/Volumes/Data/experimentData/osdi2018/social-network/'
latency_log = 'latency_client_overall_average.log'
throughput_log = 'throughput_client_overall_aggregate.log'

GRAPHS = ['0.01', '0.05', '0.10']
throughputs = []
labels = []
line_style = 0
color = 0
width = 0.2

RUN_MODES = ['DSSMR', 'DYNASTAR', 'SSMR']
COMMANDS = ['purepost']
PARTITIONS = [1, 2, 4, 8]
PARTITIONS = [2, 4, 8]
MOVE_LOG = ''
NODES = range(10001, 10099)
GRAPHS = ['0.0', '0.01', '0.05', '0.10']
GRAPHS = ['0.0', '0.01', '0.05', '0.10']

plot_data = []

latency_log = 'latency_client_overall_average.log'
throughput_log = 'throughput_client_overall_aggregate.log'

for graph in GRAPHS:
    peak_throughputs = []
    for partition in PARTITIONS:
        peak_throughput = {
            'DSSMR': 0,
            'DYNASTAR': 0,
            'SSMR': 0,
            'partition': partition
        }
        for mode in RUN_MODES:
            # client = BASE_CLIENT[mode] * (partition / 2)
            # if graph == '0' or partition == 1:
            #     client = 200 * partition
            folder = ['purepost', graph, mode, 'p', partition]
            folder = "_".join([str(val) for val in folder])
            root = ROOT + graph + '/'
            folder = common.get_folder_in_path(root, folder)
            if folder is not None:
                folder += '/details/'
                tp = collect_peak_tp(folder)
                peak_throughput[mode] = tp['peak']
                if mode == 'DSSMR': peak_throughput[mode] = tp['avg']
                # folder += '/'
                # throughput_file = common.get_file_in_path(folder, throughput_log)
                # if throughput_file is not None:
                #     tp = common.read_aggregate_log(throughput_file)
                #     peak_throughput[mode] = tp

        peak_throughputs.append(peak_throughput)
    peak_throughputs = map(
        lambda x: [x['partition'], x['DSSMR'], x['DYNASTAR'], x['SSMR']],
        peak_throughputs)
    plot_data.append({
        'graph': graph,
        'data': peak_throughputs
    })

throughputs = []
labels = []
line_style = 0
color = 0
width = 0.2
MOVE_LOG = ''

ROOT = '/Volumes/Data/experimentData/osdi2018/social-network-latency-new/'
latency_log = 'latency_client_conservative_overall_average.log'
throughput_log = 'throughput_client_conservative_overall_aggregate.log'


# NODES = range(18, 98)


def collect_95_percentile_lat_old(folder):
    lats = []
    trim = 20
    folder += 'details/'
    for (dirname, dirs, files) in os.walk(folder):
        for filename in files:
            if 'latency_client_conservative_overall_' in filename:
                f = open(folder + filename)
                reduce_factor = 1
                lineCount = 0
                for line in f:
                    if line.startswith('#'):
                        if "(ns)" in line:
                            reduce_factor = 1000000
                        elif "(cps)" in line:
                            reduce_factor = 1000
                        continue
                    lineCount = lineCount + 1
                    if lineCount > trim:
                        tmp = [float(field) for field in line.strip().split()]
                        record = (tmp[2] / reduce_factor)
                        lats.append(record)
    lats.sort()
    return lats[int(len(lats) * 0.95)]
    # print folder, lats


def collect_95_percentile_lat(folder):
    lats = []
    trim = 10
    folder += 'details/'
    prefix = 'latency_client_overall_'
    if 'DSSMR' in folder or '/0.0/' in folder:
        prefix = 'latency_client_conservative_overall_'
    for (dirname, dirs, files) in os.walk(folder):
        for filename in files:
            if prefix in filename:
                f = open(folder + filename)
                reduce_factor = 1
                lineCount = 0
                for line in f:
                    if line.startswith('#'):
                        if "(ns)" in line:
                            reduce_factor = 1000000
                        elif "(cps)" in line:
                            reduce_factor = 1000
                        continue
                    lineCount = lineCount + 1
                    if lineCount > trim:
                        tmp = [float(field) for field in line.strip().split()]
                        record = (tmp[2] / reduce_factor)
                        lats.append(record)
    lats.sort()
    # return lats
    return lats[int(len(lats) * 0.95)]
    # print folder, lats


# plot_data = []
for graph in GRAPHS:
    avg_latencies = []
    for partition in PARTITIONS:
        avg_lat = {
            'DSSMR': [],
            'DYNASTAR': [],
            'SSMR': [],
            'partition': partition
        }
        for mode in RUN_MODES:
            # client = BASE_CLIENT[mode] * (partition / 2)
            # if graph == '0' or partition == 1:
            #     client = 200 * partition
            folder = ['purepost', graph, mode, 'p', partition]
            folder = "_".join([str(val) for val in folder])
            root = ROOT + graph + '/'
            folder = common.get_folder_in_path(root, folder)
            if folder is not None:
                folder += '/'
                if 'DSSMR' in folder: latency_log = 'latency_client_conservative_overall_average.log'
                latency_file = common.get_file_in_path(folder, latency_log)
                if latency_file is not None:
                    avg = common.read_aggregate_log(latency_file)
                    # p95 = collect_95_percentile_lat_old(folder)
                    p95 = collect_95_percentile_lat(folder)
                    avg_lat[mode] = [avg, p95]
                    # if graph == '0': lat -= 4
        avg_latencies.append(avg_lat)
    avg_latencies = map(
        lambda x: [x['partition'],
                   x['DSSMR'][0], x['DSSMR'][1] - x['DSSMR'][0],
                   x['DYNASTAR'][0], x['DYNASTAR'][1] - x['DYNASTAR'][0],
                   x['SSMR'][0], x['SSMR'][1] - x['SSMR'][0], 0], avg_latencies)
    plot_data.append({
        'graph': graph,
        'data': avg_latencies,
    })

print plot_data

output_data = {}

for percentage in plot_data:

    if not percentage['graph'] in output_data: output_data[percentage['graph']] = {}
    for i in percentage['data']:
        partition = i[0]
        if not partition in output_data[percentage['graph']]: output_data[percentage['graph']][partition] = []

        output_data[percentage['graph']][partition] += i[1:]

for graph in GRAPHS:
    f = open('social-network-tp-lat-' + str(graph) + '-edgecut.dat', 'w')
    f.write('# Partitions DSSMR-tp DYNASTAR-tp SSMR-tp DSSMR-lat DSSMR-lat-95th DYNASTAR-lat DYNASTAR-lat-95th SSMR-lat SSMR-lat-95th\n')
    for partition in PARTITIONS:
        line = " ".join([str(val) for val in output_data[graph][partition]])
        f.write(str(partition) + ' ' + line + '\n')
    f.close()

#
# graph_file = "./plotted/throughput-latency-together.ps"
# plot_multi("a", plot_data, graph_file, ['0% Edge-cut', '1% Edge-cut', '5% Edge-cut', '10% Edge-cut'])
# fix_partitioning(graph_file)
# print(graph_file + " saved")
