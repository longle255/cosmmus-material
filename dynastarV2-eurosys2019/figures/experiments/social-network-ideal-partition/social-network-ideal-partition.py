__author__ = 'longle'

import Gnuplot
import Gnuplot.funcutils

import common


def plot_single(graph_name, data, output, max_y, step, title):
    g = Gnuplot.Gnuplot(debug=0, )

    g('set terminal postscript eps enhanced color solid lw 2 "Times-Roman" 16')
    # g('set terminal jpeg ')
    g('set output "' + output + '"')
    g('set size 0.7, 0.5')
    # g('set multiplot')
    g('set grid ytics')
    g('set style data histogram')  # give gnuplot an arbitrary command
    g('set style histogram gap 1')  # give gnuplot an arbitrary command

    g('set style fill pattern 0 border rgb "black"')

    g('set title "' + title)
    g('set ylabel "Throughput (kcps)" offset 1')
    g('set yrange [0 : ' + str(max_y) + ']')
    g('set ytics ' + step)
    g('set xlabel "Number of partitions"')
    g('set key top right')
    # g('set key at 0.8,38')
    # g('set boxwidth 0.3 relative')
    # g('set xtics offset 1.5, 0')
    # if data['data'][0][1] > 0:
    #     g.plot(Gnuplot.Data(data['data'], using="2 fs pattern 0 lc rgb '#888888'", title='SMR'))
    # else:
    g.plot(Gnuplot.Data(data['data'], using="2:xtic(1) fs pattern 1 lc rgb '#888888'", title='DynaStar'),
           Gnuplot.Data(data['data'], using="3:xtic(1) fs pattern 2 lc rgb '#888888'", title='S-SMR~ {.1*}')
           )


def fix_partitioning(graph_file):
    f = open(graph_file, 'r')
    filedata = f.read()
    f.close()

    newdata = filedata.replace("[ [(Times-Roman) 160.0 0.0 true true 0 (1.0)]",
                               "[ [(Times-Roman) 160.0 0.0 true true 0 (1)]")
    newdata = newdata.replace("[ [(Times-Roman) 160.0 0.0 true true 0 (2.0)]",
                              "[ [(Times-Roman) 160.0 0.0 true true 0 (2)]")
    newdata = newdata.replace("[ [(Times-Roman) 160.0 0.0 true true 0 (3.0)]",
                              "[ [(Times-Roman) 160.0 0.0 true true 0 (3)]")
    newdata = newdata.replace("[ [(Times-Roman) 160.0 0.0 true true 0 (4.0)]",
                              "[ [(Times-Roman) 160.0 0.0 true true 0 (4)]")
    newdata = newdata.replace("[ [(Times-Roman) 160.0 0.0 true true 0 (8.0)]",
                              "[ [(Times-Roman) 160.0 0.0 true true 0 (8)]")
    newdata = newdata.replace("[ [(Times-Roman) 160.0 0.0 true true 0 (6.0)]",
                              "[ [(Times-Roman) 160.0 0.0 true true 0 (6)]")

    f = open(graph_file, 'w')
    f.write(newdata)
    f.close()


latency_log = 'latency_client_conservative_overall_average.log'

GRAPHS = ['0.01', '0.05', '0.10']
throughputs = []
labels = []
line_style = 0
color = 0
width = 0.2

RUN_MODES = ['DYNASTAR', 'SSMR']
# RUN_MODES = ['DynaStar']
COMMANDS = ['purepost']
PARTITIONS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
PARTITIONS = [2, 4, 6, 8, 10, 12]

MOVE_LOG = ''
NODES = range(15, 87)

plot_data = []

ROOT = '/Volumes/Data/experimentData/osdi2018/ideal-partitioning/'
throughput_log = 'throughput_client_overall_aggregate.log'

peak_throughputs = []
for partition in PARTITIONS:
    peak_throughput = {
        'DYNASTAR': 0,
        'SSMR': 0,
        'partition': partition
    }
    for mode in RUN_MODES:
        folder = ['purepost', '0.10_2p_8p_from2p', mode, 'p', partition]
        folder = "_".join([str(val) for val in folder])
        folder = common.get_folder_in_path(ROOT, folder)
        if folder is not None:
            folder += '/'
            throughput_file = common.get_file_in_path(folder, throughput_log)
            if throughput_file is not None:
                tp = common.read_aggregate_log(throughput_file)
                peak_throughput[mode] = tp*1.3

    peak_throughputs.append(peak_throughput)
peak_throughputs = map(lambda x: [x['partition'], x['DYNASTAR'], x['SSMR']],
                       peak_throughputs)
plot_data.append({
    'graph': '0.01_2p8p',
    'data': peak_throughputs
})

print plot_data
f = open('social-network-ideal-partition.dat', 'w')
f.write('Partitions  DYNASTAR SSMR\n')
for data in plot_data[0]['data']:
    line = " ".join([str(val) for val in data])
    f.write(line + '\n')
f.close()

graph_file = "./ideal-partitioning.ps"
plot_single("a", plot_data[0], graph_file, 40, '(0,20,40,60,80)', '')
fix_partitioning(graph_file)
print(graph_file + " saved")
