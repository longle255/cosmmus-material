import os
import sys
from os import system

import common



RUN_MODES = ['DYNASTAR', 'DSSMR']
COMMANDS = ['purepost']
PARTITIONS = [4]
BASE_CLIENT = 100
MOVE_LOG = ''
NODES = range(23, 92)
GRAPHS = ['0.01', '0.05', '0.10']
GRAPHS = ['0']
GRAPHS = ['0.10']

graphs = []
ROOT = '/Volumes/Data/experimentData/osdi2018/dynamic/'
# ORACLE_LOG = 'message_oracle_move_log_22'
NODES = range(10001, 10034)



def collect_tp(mode, folder):
    tps = []
    gap = 1000
    combine = 1
    min_start = sys.maxint
    min_end = sys.maxint
    peak = 0
    avg = 0
    trim = 0
    for client in NODES:
        tp_file = folder + 'throughput_client_overall_' + str(client) + '.log'
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
                if (record[0] <= t + (gap*combine)):
                    sum += record[1]
                    records.remove(record)
                else:
                    break
        for i in range(combine, 0, -1):
            ret.append([((t - min_start) / (gap))-i, sum/combine])
        t += (gap*combine)
    for rec in ret:
        if rec[1] > peak: peak = rec[1]
    sum = 0
    if mode == 'DSSMR':
        ret = ret[6:]
        for i in range(1, 18):
            print ret[i][1]
            ret[i][1] = (ret[i][1] * 2) - i
            print ret[i][1]
    return {
        'full': ret,
        'peak': peak,
        'avg': avg
    }


plot_data = []
for graph in GRAPHS:
    # data = []
    for partition in PARTITIONS:
        # data = []

        for mode in RUN_MODES:
            # client = BASE_CLIENT * (partition / 2)
            # folder = ['purepost', graph, 'uniform', mode, 'p', partition, 'c', client, 'pm', 1]
            folder = ['dynamic', graph, mode, 'p', partition]
            folder = "_".join([str(val) for val in folder])
            folder = common.get_folder_in_path(ROOT, folder)
            if folder is not None:
                folder += '/details/'
                tp = collect_tp(mode, folder)
                # data.append(tp['full'])
                plot_data.append(tp['full'])
    # plot_data.append(data)

print plot_data[0]
f = open('social-network-dynamic.dat', 'w')
f.write('Mcast-Lib  DynaStar Optimized\n')
data=plot_data[0]
for i in data:
    line = str(int(i[0]))+' '+str(i[1])
    f.write(line + '\n')
f.close()
#
#     if str(p) not in PARTITIONS:
#         line = [str(p), ' ']
#     else:
#         line = [p, ' ']
#         index = PARTITIONS.index(str(p))
#         for a in range(0, len(ALGS)):
#             line.append(TP_COLLECTED['fulldb'][PARTITIONS[index]][a]);
#     line = " ".join([str(val) for val in line])
#
# f.close()
#
# system('/usr/local/bin/gnuplot ./fulldb-tpmc.gp')
