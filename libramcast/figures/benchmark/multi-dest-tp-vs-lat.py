import os

import common

ROOT = '/Users/longle/Documents/Workspace/PhD/ScalableSMR/plotting/libRamcastV3/data/xl170/take 6/max-multi-dest-1248-group/'

CLIENTS = range(1, 10)
DESTINATIONS = [1, 2, 4, 8]


def collect_number(folder, file):
    tp_file = folder + '/' + file
    if not os.path.isfile(tp_file):
        return None
    f = open(tp_file)
    reduce_factor = 1
    records = []
    start = None
    end = None
    i = 1
    for line in f:
        if line.startswith('#'):
            if "(ns)" in line:
                reduce_factor = 1000
            elif "(cps)" in line:
                reduce_factor = 1000
            continue
        tmp = [float(field) for field in line.strip().split()]
        if start == None: start = tmp[0]
        end = tmp[0]
        records.append([i, (tmp[2] / reduce_factor)])
        i = i + 1
    f.close()
    return records[0]


plot_data = {}
command = 'mix'
for dest in DESTINATIONS:
    plot_data = []
    for client in CLIENTS:
        folder = [dest, 'd', '-', client, 'c']
        folder = "".join([str(val) for val in folder])
        folder = common.get_folder_in_path(ROOT, folder)
        if folder is not None:
            folder += '/'
            tp = collect_number(folder, 'throughput_client_overall_aggregate.log')
            lat = collect_number(folder, 'latency_client_overall_average.log')

            plot_data.append([client, tp[1], lat[1]])

    f = open('./data-aggregated/multi-dest-tp-vs-lat-{}.dat'.format(dest), 'w')
    f.write('# Clients Throughput Latency\n')
    for point in plot_data:
        f.write('{} {} {}\n'.format(point[0],point[1],point[2]))
    f.close()

print plot_data

os.system('/usr/local/bin/gnuplot ./multi-dest-tp-vs-lat.gp')
