import sys

__author__ = 'longle'

import Gnuplot
import Gnuplot.funcutils
from os.path import isfile as file_exists

import common


def plot_tp_strong_locality(graph_name, graphs, output, graph_config):
    g = Gnuplot.Gnuplot(debug=0, )
    g('set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16')
    g('set output "' + output + '"')
    g('set size 1, 0.9')
    g('set size ratio 0.5')
    # g.title('Strong locality')

    g('set grid ytics')
    g('set style data lines')  # give gnuplot an arbitrary command

    g('set xrange ' + graph_config['xrange'])

    g('set ylabel "Thousand commands/sec" offset 1.5')
    g('set xlabel "Time(s)"')
    g('set yrange [0:20]')
    g('set ytics 0,5,20')
    g('set key bottom right')
    data = graphs[2]
    g('set style func linespoints')
    g.plot(Gnuplot.PlotItems.Data(data[0], using="2", with_="line lt 1 lw 2", title="Dynamic decentralized"),
           Gnuplot.PlotItems.Data(data[1], using="2", with_="line ls 3 lw 2", title="Optimum static"))

    g.reset()


def plot_tp_weak_locality(graph_name, graphs, output, graph_config):
    g = Gnuplot.Gnuplot(debug=0, )
    g('set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16')
    g('set output "' + output + '"')
    g('set size 1, 0.9')
    g('set size ratio 0.5')
    # g.title('Strong locality')

    g('set grid ytics')
    g('set style data lines')  # give gnuplot an arbitrary command

    g('set xrange ' + graph_config['xrange'])

    g('set ylabel "Thousand commands/sec" offset 1.5')
    g('set xlabel "Time(s)"')
    g('set key top right')
    g('set yrange [0:20]')
    g('set ytics 0,5,20')
    data = graphs[3]
    g('set style func linespoints')
    g.plot(Gnuplot.PlotItems.Data(data[0], using="2", with_="line lt 1 lw 2", title="Dynamic decentralized"),
           Gnuplot.PlotItems.Data(data[1], using="2", with_="line ls 3 lw 2", title="Optimum static"))

    g.reset()


def plot_moves_strong_locality(graph_name, graphs, output, graph_config):
    g = Gnuplot.Gnuplot(debug=0, )
    g('set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16')
    g('set output "' + output + '"')
    g('set size 1, 0.9')
    g('set size ratio 0.5')
    # g.title('Weak locality')

    g('set grid ytics')
    g('set style data lines')  # give gnuplot an arbitrary command

    g('set xrange ' + graph_config['xrange'])

    g('set key bottom right')

    g('set style func linespoints')
    g('set ylabel "Moves/sec" offset 1.95')
    g('set xlabel "Time(s)"')

    g('set yrange [0:1000]')
    g('set ytics 0,200,1000')
    data = graphs[0]
    g.plot(Gnuplot.PlotItems.Data(data[0], using="2", with_="line lt 1 lw 2", title="Dynamic decentralized"))

    g.reset()


def plot_moves_weak_locality(graph_name, graphs, output, graph_config):
    g = Gnuplot.Gnuplot(debug=0, )
    g('set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16')
    g('set output "' + output + '"')
    g('set size 1, 0.9')
    g('set size ratio 0.5')
    # g.title('Weak locality')

    g('set grid ytics')
    g('set style data lines')  # give gnuplot an arbitrary command

    g('set xrange ' + graph_config['xrange'])

    g('set ylabel "Thousand commands/sec" offset 1.5')
    g('unset xlabel')
    g('set key bottom right')

    g('set style func linespoints')
    g('set ylabel "Moves/sec" offset 1.95')
    g('set xlabel "Time(s)"')

    g('set yrange [0:1000]')
    g('set ytics 0,200,1000')
    data = graphs[1]
    g.plot(Gnuplot.PlotItems.Data(data[0], using="2", with_="line lt 1 lw 2", title="Dynamic decentralized"))

    g.reset()


def plot_all(graph_name, graphs, output, graph_config):
    g = Gnuplot.Gnuplot(debug=0, )
    g('set terminal postscript eps enhanced color solid lw 1.5 "Times-Roman" 16')
    g('set output "' + output + '"')
    g('set size 1, 0.9')
    g('set size ratio 0.5')

    g('set multiplot layout 2,2 margins 0.1,0.98,0.1,0.98 spacing 0.08,-0.9 ')
    g('set label "Strong locality" at screen 0.3,0.85 center')
    g('set label "Weak locality" at screen 0.8,0.85 center')

    g('set grid ytics')
    g('set style data lines')  # give gnuplot an arbitrary command

    g('set xrange ' + graph_config['xrange'])

    g('set ylabel "Thousand commands/sec" offset 1.5')
    g('unset xlabel')
    g('set key bottom right')
    g('set yrange [0:20]')
    g('set ytics 0,5,20')
    data = graphs[2]
    g('set style func linespoints')
    g.plot(Gnuplot.PlotItems.Data(data[0], using="2", with_="line lt 1 lw 2", title="Dynamic decentralized"),
           Gnuplot.PlotItems.Data(data[1], using="2", with_="line ls 3 lw 2", title="Optimum static"))

    g('unset ylabel')
    g('set yrange [0:20]')
    g('set ytics 0,5,20')
    data = graphs[3]
    g.plot(Gnuplot.PlotItems.Data(data[0], using="2", with_="line lt 1 lw 2"),
           Gnuplot.PlotItems.Data(data[1], using="2", with_="line lt 3 lw 2"))

    g('set ylabel "Moves/sec" offset 1.95')
    g('set xlabel "Time(s)"')
    g('set yrange [0:1000]')
    g('set ytics 0,200,1000')
    data = graphs[0]
    g.plot(Gnuplot.PlotItems.Data(data[0], using="2", with_="line lt 1 lw 2"))

    g('set yrange [0:1000]')
    g('set ytics 0,200,1000')
    g('unset ylabel')
    data = graphs[1]
    g.plot(Gnuplot.PlotItems.Data(data[0], using="2", with_="line lt 1 lw 2"))

    g.reset()


RUN_MODES = ['DSSMR', 'SSMRMetis']
ACCESS_MODES = ['uniform']
COMMANDS = ['purepost']
PARTITIONS = [4]
CLIENTS = [400]
MOVE_LOG = ''
MOVE_GRAPHS_TYPE = [{
    'type': '0',
    'log': 'message_oracle_move_log_26.log',
    'client': '100',
    'gap': 100,
    'graph_config': {
        'xrange': '[0:1800]',
        # 'xtics': '("0" 0, "1" 10, "2" 20, "3" 30,"4" 40,"5" 50,"6" 60,"7" 70,"8" 80,"9" 90,)'
    }
}, {
    'type': '0.01',
    'log': 'message_oracle_move_log_26.log',
    'client': '100',
    'gap': 100,
    'graph_config': {
        'xrange': '[0:180]',
        # 'xtics': '0,10,90'
    }
}]
TP_GRAPHS_TYPE = [
    {
        'type': '0',
        'log': 'message_oracle_move_log_26.log',
        'client': '100',
        'gap': 100,
        'nodes': range(28, 92),
        'graph_config': {
            'xrange': '[0:180]',
            'xtics': '0,10,180',
            'max_y': '45'
        }

    }
    , {
        'type': '0.01',
        'log': 'message_oracle_move_log_26.log',
        'client': '100',
        'gap': 1000,
        'nodes': range(28, 84),
        'graph_config': {
            'xrange': '[0:180]',
            'xtics': '0,10,180',
            'max_y': '25'
        }
    }
]


def collect_intersec_tp(graph, folder):
    tps = []
    max_start = -1
    min_end = sys.maxint
    for client in graph['nodes']:
        tp_file = folder + 'throughput_client_conservative_overall_' + str(client) + '.log'
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

        if max_start < start: max_start = start
        if min_end > end: min_end = end
        tps.append(records)
    min_len = sys.maxint
    for records in tps:
        records = filter(lambda x: max_start < x[0] < min_end, records)
        if min_len > len(records): min_len = len(records)
    tps = map(lambda x: x if len(x) == min_len else x[:min_len - 1], tps)

    ret = []
    for i in range(0, min_len - 1):
        sum = 0
        for records in tps:
            sum += records[i][1]
        ret.append([records[0][0] - max_start, sum])
    return ret


def collect_tp(graph, folder):
    tps = []
    gap = 1000
    min_start = sys.maxint
    min_end = sys.maxint
    for client in graph['nodes']:
        tp_file = folder + 'throughput_client_conservative_overall_' + str(client) + '.log'
        if not file_exists(tp_file): continue
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
    return ret


def aggregate_move(file, gap):
    f = open(file)
    now = -1
    count = 0
    ret = []
    start = -1;
    for line in f:
        if "MOVE" in line:
            time = int((line.strip().split())[0])
            if now < 0:
                now = time
                start = time
                continue
            if (time > now + gap):
                ret.append([(now - start) / 1000, count])
                now = time
                count = 0
            else:
                count += 1
    f.close()
    if len(ret) > 173: ret = ret[0:173]
    return ret


graphs = []
for graph_type in MOVE_GRAPHS_TYPE:
    data = []
    ROOT = './data/dsn/motivation/' + graph_type['type'] + '/'
    for partition in PARTITIONS:
        for mode in RUN_MODES:
            folder = ['purepost', 'uniform', mode, 'p', partition, 'c', graph_type['client'], 'pm', 1,
                      'p_1.0_f_0.0_uf_0.0_tl_0.0_#_']
            folder = "_".join([str(val) for val in folder])
            folder = common.get_folder_in_path(ROOT, folder)
            if folder is not None:
                folder += '/details/server_log_chitter/'
                move_log = common.get_file_in_path(folder, graph_type['log'])
                if move_log is not None:
                    data.append(aggregate_move(move_log, graph_type['gap']))
    graphs.append(data)

for graph_type in TP_GRAPHS_TYPE:
    data = []
    ROOT = './data/dsn/motivation/' + graph_type['type'] + '/'
    for partition in PARTITIONS:
        data = []
        for mode in RUN_MODES:
            folder = ['purepost', 'uniform', mode, 'p', partition, 'c', graph_type['client'], 'pm', 1,
                      'p_1.0_f_0.0_uf_0.0_tl_0.0_#_']
            folder = "_".join([str(val) for val in folder])
            folder = common.get_folder_in_path(ROOT, folder)
            if folder is not None:
                folder += '/details/'
                line = collect_tp(graph_type, folder)
                data.append(line)
                print data
    graphs.append(data)

graph_file = "./data/dsn/motivation"
plot_tp_strong_locality("DSSMR ", graphs, graph_file + "-tp-strong-locality.ps", graph_type['graph_config'])
plot_tp_weak_locality("DSSMR ", graphs, graph_file + "-tp-weak-locality.ps", graph_type['graph_config'])
plot_moves_strong_locality("DSSMR ", graphs, graph_file + "-moves-strong-locality.ps", graph_type['graph_config'])
plot_moves_weak_locality("DSSMR ", graphs, graph_file + "-moves-weak-locality.ps", graph_type['graph_config'])

plot_all("DSSMR ", graphs, graph_file + "-all.ps", graph_type['graph_config'])

print(graph_file + " saved")
