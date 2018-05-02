import os
import sys

import common

ROOT = '/Volumes/Data/experimentData/osdi2018/tpcc/repartitioning/'
NODES = range(10001, 10034)
DATASET = 'default_DYNASTAR_p_4_c_4_no_45_p_43_d_4_os_4_sl_4_'

PARTITION_NODES = range(0, 4);


def collect_global_rate(folder):
    tps = []
    gap = 1000
    combine = 1
    min_start = sys.maxint
    min_end = sys.maxint
    peak = 0
    avg = 0
    trim = 0
    for server in PARTITION_NODES:
        tp_file = folder + '/server/throughput_partition_move_' + str(server) + '.log'
        if not os.path.isfile(tp_file):
            continue
        f = open(tp_file)
        reduce_factor = 1
        records = []
        start = None
        end = None
        for line in f:
            if line.startswith('#'):
                #     if "(ns)" in line:
                #         reduce_factor = 1000000
                #     elif "(cps)" in line:
                #         reduce_factor = 1000
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
                if (record[0] <= t + (gap * combine)):
                    sum += record[1]
                    records.remove(record)
                else:
                    break
        for i in range(combine, 0, -1):
            ret.append([((t - min_start) / (gap)) - i, sum / combine])
        t += (gap * combine)
    smooth = [];
    last = -1
    for rec in ret:
        if rec[1] > peak: peak = rec[1]

        if (last != -1):
            now = 0
            if (rec[1] == 0):
                now = rec[1]
            else:
                now = (rec[1] + last[1]) / 2
            smooth.append([(rec[0] + last[0]) / 2, now])
            # if rec[1] < last[1] * 0.5:
            #     rec[1] = last[1] * random.uniform(0.3, 0.8)
        smooth.append([rec[0], rec[1]])
        last = rec

    return {
        'full': ret[90:],
        'peak': peak,
        'avg': avg,
        'smooth': smooth
    }


def collect_lat(folder):
    lats = []
    gap = 1000
    combine = 1
    min_start = sys.maxint
    min_end = sys.maxint
    peak = 0
    avg = 0
    trim = 0
    for client in NODES:
        tp_file = folder + 'latency_client_overall_' + str(client) + '.log'
        if not os.path.isfile(tp_file):
            continue
        f = open(tp_file)
        records = []
        start = None
        end = None
        for line in f:
            if line.startswith('#'):
                continue
            tmp = [float(field) for field in line.strip().split()]
            if start == None: start = tmp[0]
            end = tmp[0]
            records.append([tmp[0], tmp[2]])
        f.close()

        if min_start > start: min_start = start
        if min_end > end: min_end = end
        lats.append(records)
    ret = []
    t = min_start
    last = 0;
    while t < min_end:
        sum = 0
        count = 1
        for records in lats:
            for record in records:
                if (record[0] <= t + (gap * combine)):
                    sum += record[1]
                    count += 1
                    records.remove(record)
                else:
                    break
        for i in range(combine, 0, -1):
            now = (sum / count) / combine
            # if now!=0: ret.append([((t - min_start) / (gap)) - i, now])
            # else:
            #     now = last * random.uniform(0.01, 2)
            ret.append([((t - min_start) / (gap)) - i, now])
            last = now
        t += (gap * combine)
    return ret
    # smooth = [];
    # last = -1
    # i = 0
    # ret = ret[3:]
    # for rec in ret:
    #     i += 1
    #     if (last != -1):
    #         smooth.append([(rec[0] + last[0]) / 2, (rec[1] + last[1]) / 2])
    #         # if rec[1] < last[1] * 0.1 and i not in range(20,50):
    #         #     rec[1] = last[1] * random.uniform(0.001, 0.1)
    #     # smooth.append([rec[0], rec[1]])
    #     last = rec
    # return smooth
    #


def collect_tp(folder):
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
                #     if "(ns)" in line:
                #         reduce_factor = 1000000
                #     elif "(cps)" in line:
                #         reduce_factor = 1000
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
                if (record[0] <= t + (gap * combine)):
                    sum += record[1]
                    records.remove(record)
                else:
                    break
        for i in range(combine, 0, -1):
            ret.append([((t - min_start) / (gap)) - i, sum / combine])
        t += (gap * combine)
    smooth = [];
    last = -1
    for rec in ret:
        if rec[1] > peak: peak = rec[1]

        if (last != -1):
            now = 0
            if (rec[1] == 0):
                now = rec[1]
            else:
                now = (rec[1] + last[1]) / 2
            smooth.append([(rec[0] + last[0]) / 2, now])
            # if rec[1] < last[1] * 0.5:
            #     rec[1] = last[1] * random.uniform(0.3, 0.8)
        smooth.append([rec[0], rec[1]])
        last = rec

    return {
        'full': ret,
        'peak': peak,
        'avg': avg,
        'smooth': smooth
    }


plot_data = []
# folder = ['purepost', graph, 'uniform', mode, 'p', partition, 'c', client, 'pm', 1]
records = []
folder = common.get_folder_in_path(ROOT, DATASET)
if folder is not None:
    folder += '/details/'
    tp = collect_tp(folder)
    lat = collect_lat(folder)
    gb = collect_global_rate(folder)
    for i in range(200):
        records.append([i, tp['full'][i][1], lat[i][1] / 1000000, gb['full'][i][1]])
    # data.append(tp['full'])
    # plot_data.append(tp['smooth'])
    # plot_data.append(lat['smooth'])

print records
# print plot_data[0]
# print plot_data[1]

f = open('tpcc-repartitioning.dat', 'w')
f.write('Time Throughput Latency\n')
# data = plot_data[0]
for i in records:
    if i[1] == 0:
        rate = i[3] / 1 * 100
    else:
        rate = i[3] / i[1] * 100
    if rate > 100: rate = 100
    line = str(i[0]) + ' ' + str(i[1]) + ' ' + str(i[2]) + ' ' + str(rate)
    f.write(line + '\n')
f.close()
#
os.system('/usr/local/bin/gnuplot ./tpcc-repartitioning.gp')
