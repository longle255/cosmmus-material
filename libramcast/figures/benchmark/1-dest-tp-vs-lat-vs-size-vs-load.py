import os

import common

ROOT = '/Users/longle/Documents/Workspace/PhD/ScalableSMR/plotting/libRamcastV3/data/xl170/take 6/max-single-dest-1-group/'
ROOT = '/Users/longle/Documents/Workspace/PhD/ScalableSMR/plotting/libRamcastV3/data/r320/take 7/max-single-dest-1-group/'

CLIENTS = [5, 6, 7, 8, 9, 10]
CLIENTS = [1, 2, 3, 4, 5, 6, 7, 8, 9]
SIZE = [98, 512, 1024, 2048, 16384, 32768, 65536]


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


for size in SIZE:
    plot_data = []
    for client in CLIENTS:
        # folder = ["1d", "-", "8g", "-", client, "c", "-", "3p", '-', size, "b"]
        folder = ["1d", "-", "5g", "-", client, "c", "-", "3p", '-', size, "b"]
        folder = "".join([str(val) for val in folder])
        folder = common.get_folder_in_path(ROOT, folder)
        if folder is not None:
            folder += '/'
            tp = collect_number(folder, 'throughput_client_overall_aggregate.log')
            lat = collect_number(folder, 'latency_client_overall_average.log')

            plot_data.append([client, tp[1], lat[1]])

    f = open('./data-aggregated/1-dest-tp-vs-lat-vs-size-vs-load-{}b.dat'.format(size), 'w')
    f.write('# Clients Throughput Latency\n')
    for point in plot_data:
        f.write('{} {} {}\n'.format(point[0], point[1], point[2]))
    f.close()

print plot_data

os.system('/opt/local/bin/gnuplot ./1-dest-tp-vs-lat-vs-size-vs-load.gp')
