#!/usr/bin/python

import glob
import os
import re
import string
import sys
from numpy.lib.scimath import sqrt



def remdups(list) :
    clean = []
    for i in list :
        if i not in clean :
            clean.append(i)
    return clean



def remnondir(list) :
    clean = []
    for name in list :
        if os.path.isdir(name) :
            clean.append(name)
    return clean



def getfileline(name, linenum) :
    linenum -= 1
    fp = open(name)
    wantedline = ""
    for i, line in enumerate(fp):
        if i == linenum:
            wantedline = line
            break
    fp.close()
    return wantedline.splitlines()[0]



def makeOverallTable_vs_rate(size) :
    listOfDirs = glob.glob("*_" + str(size) + "bytes*")
    listOfDirs = remnondir(listOfDirs)
    
    rates = []
    for dir in listOfDirs :
        rate = float(re.split("r", dir)[0])
        rates.append(rate)
    
    rates = remdups(rates)
    rates.sort()
    
    zkFileName  = "read_rates_zk_"  + str(size) + "bytes.txt"
    smrFileName = "read_rates_smr_" + str(size) + "bytes.txt"
    mergedFileName = "read_rates_"  + str(size) + "bytes.txt"
    
    tableLines = []
    header = "# read-rate tp lat@tp cpu@tp bwr@tp bww@tp\n"
    ZKtableLines  = [ header ]
    SMRtableLines = [ header ]
    mergedTableLines = [ "# read-rate zk(tp lat@tp cpu@tp bwr@tp bww@tp) smr(tp lat@tp cpu@tp bwr@tp bww@tp)\n" ]
    
    for rate in rates :
        dir = str(rate) + "readrate_" + str(size) + "bytes/"
        zkMaxFile = dir + "ZK_max_tp.txt"
        smrMaxFile = dir + "SMR_max_tp.txt"
        zkline  = str(rate) + " " + getfileline(zkMaxFile , 2) + "\n"
        smrline = str(rate) + " " + getfileline(smrMaxFile, 1) + "\n"
        mergedline = str(rate) + " " + getfileline(zkMaxFile , 1) + " " + getfileline(smrMaxFile, 1) + "\n"
        ZKtableLines.append(zkline)
        SMRtableLines.append(smrline)
        mergedTableLines.append(mergedline)
    
    zkFile = open(zkFileName, 'w')
    for line in ZKtableLines :
        zkFile.write(line)
    
    smrFile = open(smrFileName, 'w')
    for line in SMRtableLines :
        smrFile.write(line)
    
    mergedFile = open(mergedFileName, 'w')
    for line in mergedTableLines :
        mergedFile.write(line)



def makeOverallTable_vs_size(rate) :
    listOfDirs = glob.glob(str(rate) + "readrate*")
    listOfDirs = remnondir(listOfDirs)
    
    sizes = []
    for dir in listOfDirs :
        size = int(re.split("[b_]", dir)[1])
        sizes.append(size)

    sizes = remdups(sizes)
    sizes.sort()
    
    #sizes = [100]
    
    zkFileName  = "sizes_zk_"  + str(rate) + "readrate.txt"
    smrFileName = "sizes_smr_" + str(rate) + "readrate.txt"
    ssmr1pFileName = "sizes_ssmr_1p_" + str(rate) + "readrate.txt"
    ssmr2pFileName = "sizes_ssmr_2p_" + str(rate) + "readrate.txt"
    ssmr4pFileName = "sizes_ssmr_4p_" + str(rate) + "readrate.txt"
    ssmr8pFileName = "sizes_ssmr_8p_" + str(rate) + "readrate.txt"
    mergedFileName = "sizes_"  + str(rate) + "readrate.txt"
    
    tableLines = []
    header = "# size tp, lat, bwr, bww, cpu, tps, brps, bwps\n"
    ZKtableLines  = [ header ]
    SMRtableLines = [ header ]
    SSMR1PtableLines = [ header ]
    SSMR2PtableLines = [ header ]
    SSMR4PtableLines = [ header ]
    SSMR8PtableLines = [ header ]
    mergedTableLines = [ "# size (tp, lat, bwr, bww, cpu, tps, brps, bwps) for zk,smr,ssmr1p,ssmr2p,ssmr4p,ssm8p\n" ]
    
    for size in sizes :
        dir = str(rate) + "readrate_" + str(size) + "bytes/"
        zkMaxFile = dir + "ZK_max_tp.txt"
        smrMaxFile = dir + "SMR_max_tp.txt"
        ssmr1pMaxFile = dir + "SSMR_1f_max_tp.txt"
        ssmr2pMaxFile = dir + "SSMR_2f_max_tp.txt"
        ssmr4pMaxFile = dir + "SSMR_4f_max_tp.txt"
        ssmr8pMaxFile = dir + "SSMR_8f_max_tp.txt"
        zkline  = str(size) + " " + getfileline(zkMaxFile , 2) + "\n"
        smrline = str(size) + " " + getfileline(smrMaxFile, 2) + "\n"
        ssmr1pline = str(size) + " " + getfileline(ssmr1pMaxFile, 2) + "\n"
        ssmr2pline = str(size) + " " + getfileline(ssmr2pMaxFile, 2) + "\n"
        ssmr4pline = str(size) + " " + getfileline(ssmr4pMaxFile, 2) + "\n"
        ssmr8pline = str(size) + " " + getfileline(ssmr8pMaxFile, 2) + "\n"
        mergedline = str(size) + " " + getfileline(zkMaxFile, 2) + " " + getfileline(smrMaxFile, 2) + " " + getfileline(ssmr1pMaxFile, 2) + " " + getfileline(ssmr2pMaxFile, 2) +" " + getfileline(ssmr4pMaxFile, 2) +" " + getfileline(ssmr8pMaxFile, 2) +"\n"
        ZKtableLines.append(zkline)
        SMRtableLines.append(smrline)
        SSMR1PtableLines.append(ssmr1pline)
        SSMR2PtableLines.append(ssmr2pline)
        SSMR4PtableLines.append(ssmr4pline)
        SSMR8PtableLines.append(ssmr8pline)
        mergedTableLines.append(mergedline)

    zkFile = open(zkFileName, 'w')
    for line in ZKtableLines :
        zkFile.write(line)

    smrFile = open(smrFileName, 'w')
    for line in SMRtableLines :
        smrFile.write(line)

    ssmr1pFile = open(ssmr1pFileName, 'w')
    for line in SSMR1PtableLines :
        smrFile.write(line)

    ssmr2pFile = open(ssmr1pFileName, 'w')
    for line in SSMR1PtableLines :
        smrFile.write(line)

    ssmr4pFile = open(ssmr1pFileName, 'w')
    for line in SSMR1PtableLines :
        smrFile.write(line)

    ssmr8pFile = open(ssmr1pFileName, 'w')
    for line in SSMR1PtableLines :
        smrFile.write(line)

    mergedFile = open(mergedFileName, 'w')
    for line in mergedTableLines :
        mergedFile.write(line)


def createLatencyCdfFile(sourceFile, precision, cdfFilePath=None) :
    # create a sorted list l of latencies
    # divide the latency list in precision slices of ~equal width w
    # for each slice y in 0..precision, create a point (x,y) where x = l[y*w]
    
    latency_list = []
    with open(sourceFile) as f :
        for line in f:
            if line.split()[0] == "#" :
                continue
            latency = int(line.split()[1])
            latency_list.append(latency)
    latency_list.sort()

    l = len(latency_list)

    if l < precision :
       print "List has only " + str(l) + " points. Reducing cdf precision to " + str(l) + "."
       precision = l
    
    w = len(latency_list) // precision     
    
    cdf = []
    for y in range(0, precision) :
        x = latency_list[y*w]
        cdf.append(x);
    
    if cdfFilePath != None :
        cdfFile = open(cdfFilePath, 'w')
        for y in range(0, precision) :
            cdfFile.write(str(cdf[y]) + " " + str(y) + "\n")
    
    return cdf    

# call this for each size found with glob.glob
def makeLatencyCdfs(rate, size) :
    dir = str(rate) + "readrate_" + str(size) + "bytes/"
    
    zkMaxTpLoad = getfileline(dir + "ZK_max_tp.txt", 2).split()[0]
    smrMaxTpLoad = getfileline(dir + "SMR_max_tp.txt", 2).split()[0]
    ssmr1pMaxTpLoad = getfileline(dir + "SSMR_1f_max_tp.txt", 2).split()[0]
    ssmr2pMaxTpLoad = getfileline(dir + "SSMR_2f_max_tp.txt", 2).split()[0]
    ssmr4pMaxTpLoad = getfileline(dir + "SSMR_4f_max_tp.txt", 2).split()[0]
    ssmr8pMaxTpLoad = getfileline(dir + "SSMR_8f_max_tp.txt", 2).split()[0]
    
    zkLatenciesFile     = "../ZK_"   + str(zkMaxTpLoad)     + "clients_" + str(rate) + "readrate_" + str(size) + "bytes_run1/clients_latency.txt"
    smrLatenciesFile    = "../SMR_"  + str(smrMaxTpLoad)    + "clients_" + str(rate) + "readrate_" + str(size) + "bytes_run1/clients_latency.txt"
    ssmr1pLatenciesFile = "../SSMR_" + str(ssmr1pMaxTpLoad) + "clients_" + str(rate) + "readrate_" + str(size) + "bytes_1fpartitions_0.0globalrate_run1/clients_latency.txt"
    ssmr2pLatenciesFile = "../SSMR_" + str(ssmr2pMaxTpLoad) + "clients_" + str(rate) + "readrate_" + str(size) + "bytes_2fpartitions_0.0globalrate_run1/clients_latency.txt"
    ssmr4pLatenciesFile = "../SSMR_" + str(ssmr4pMaxTpLoad) + "clients_" + str(rate) + "readrate_" + str(size) + "bytes_4fpartitions_0.0globalrate_run1/clients_latency.txt"
    ssmr8pLatenciesFile = "../SSMR_" + str(ssmr8pMaxTpLoad) + "clients_" + str(rate) + "readrate_" + str(size) + "bytes_8fpartitions_0.0globalrate_run1/clients_latency.txt"
    
    zkLatCdf         = createLatencyCdfFile(zkLatenciesFile    , 1000, dir + "ZK_LatCdf.txt"    )
    smrLatCdf        = createLatencyCdfFile(smrLatenciesFile   , 1000, dir + "SMR_LatCdf.txt"   )
    ssmr1pLatencyCdf = createLatencyCdfFile(ssmr1pLatenciesFile, 1000, dir + "SSMR_1p_LatCdf.txt")
    ssmr2pLatencyCdf = createLatencyCdfFile(ssmr2pLatenciesFile, 1000, dir + "SSMR_2p_LatCdf.txt")
    ssmr4pLatencyCdf = createLatencyCdfFile(ssmr4pLatenciesFile, 1000, dir + "SSMR_4p_LatCdf.txt")
    ssmr8pLatencyCdf = createLatencyCdfFile(ssmr8pLatenciesFile, 1000, dir + "SSMR_8p_LatCdf.txt")

def makeAllLatencyCdfs(rate) :
    listOfDirs = glob.glob(str(rate) + "readrate*")
    listOfDirs = remnondir(listOfDirs)
    
    sizes = []
    for dir in listOfDirs :
        size = int(re.split("[b_]", dir)[1])
        sizes.append(size)

    sizes = remdups(sizes)
    sizes.sort()

    print "cdf sizes = " + str(sizes)
   
    #sizes = [100]
    
    for size in sizes :
        makeLatencyCdfs(rate, size)
    
    
# ===============================================================================
# END OF FUNCTIONS
# ===============================================================================





# ===============================================================================
# BEGINNING OF PROGRAM
# ===============================================================================

listOfDirs = glob.glob("*bytes")
listOfDirs = remnondir(listOfDirs)

############
# tp vs rr #
############
sizes = []
for dir in listOfDirs :
    size = int(re.split("[b_]", dir)[1])
    sizes.append(size)

sizes = remdups(sizes)

for size in sizes :
    makeOverallTable_vs_rate(size)

##############
# tp vs size #
##############

rates = []
for dir in listOfDirs :
    rate = float(re.split("r", dir)[0])
    rates.append(rate)

rates = remdups(rates)

for rate in rates :
    makeOverallTable_vs_size(rate)

makeAllLatencyCdfs("0.0")
