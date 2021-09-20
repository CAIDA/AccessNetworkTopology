#! /usr/bin/env python3
import bz2
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-v", dest="ip_version",  type=int, default=4)
args = parser.parse_args()
ip_version = args.ip_version

version_fname = {
    4:"/data/external/as-rank-ribs/20200301/20200301.prefix2as.bz2",
    6:"/data/external/as-rank-ribs/20200301/20200301.prefix2as6.bz2",
    }
fname = version_fname[ip_version]

args = parser.parse_args()
ip_version = args.ip_version

with bz2.BZ2File(fname) as f:
    for line in f:
        line = line.decode()
        if len(line) < 0 or line[0] == '#':
            continue
        values = line.rstrip().split("\t")
        if len(values) == 3:
            print (values[0]+"/"+values[1]+"\t"+values[2])
