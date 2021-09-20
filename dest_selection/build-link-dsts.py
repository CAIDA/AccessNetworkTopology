#! /usr/bin/env python3
import subprocess
import re
import sys
import json
import pyasn
import gzip
import argparse
#from sc_warts import WartsReader

parser = argparse.ArgumentParser()
parser.add_argument("-v", dest="ip_version",  type=int, default=4)
global asndb 
args = parser.parse_args()
ip_version = args.ip_version

sc_warts = "/home/mjl/scamper/bin/sc_warts2json"
as_org_file = "/data/external/whois-database-dumps/202001/as2org/20200101.as-org2info.txt.gz"

link_dsts = {}

if ip_version == 4:
    asndb = pyasn.pyasn("prefix2as.txt")
    ls_ark_files = "ls /data/topology/ark/data/team-probing/list-7.allpref24/team-1/daily/202*/cycle-2020032*/*c008268*"
elif ip_version == 6:
    asndb = pyasn.pyasn("prefix2as6.txt")
    ls_ark_files = "ls /data/topology/ark/data/topo-v6/list-8.ipv6.allpref/2020/03/*20200331*"

def main():
    server_files = parse_files()
    as2country = load_as_org(as_org_file);
    process(server_files,as2country)
    for link,dsts in link_dsts.items():
        print (link+","+",".join(dsts))

def process(server_files, as2country):
    for server,files in server_files.items():
        print (server,file=sys.stderr)
        for file in files:
            print ("    ",file,file=sys.stderr)
            print ("#",server,file)
            command = "gunzip -c "+file+" | "+sc_warts
            proc = subprocess.Popen(command,
                    shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            out,err = proc.communicate()
            if len(err) > 0:
                print (err.decode(),file=sys.stderr)
                sys.exit()

            for line in out.decode().split("\n"):
                if len(line) < 1:
                    continue

                try:
                    info = json.loads(line)
                except:
                    print ("JSON error:",line,file=sys.stderr)
                    continue 

                if (ip_version == 6 and "hops" in info and info["stop_reason"] != "GAPLIMIT") or "COMPLETED" == info["stop_reason"]:
                    #print(json.dumps(info, indent=4, sort_keys=True))
                    ips = [None] * (info["hop_count"]+1)
                    for hop in info["hops"]:
                        ips[hop["probe_ttl"]] = hop["addr"]
                    i_asn = ips[0]
                    for j in range(1,len(ips)):
                        j_ip = ips[j]
                        if j_ip is not None:
                            j_asn,j_prefix = asndb.lookup(j_ip)
                            if j_asn is not None:
                                j_asn = str(j_asn)
                                if i_asn is not None and j_asn != i_asn:
                                    add(i_asn, j_asn, info["dst"])
                                i_asn = j_asn
                                if j_asn in as2country and as2country[j_asn] != "US":
                                    break


def add(i,j,d):
    #print (i,j,d)
    if i > j:
        t = i
        i = j
        j = t
    link = str(i)+" "+str(j)
    if link not in link_dsts:
        link_dsts[link] = set()
    link_dsts[link].add(d)

def parse_files(): 
    proc = subprocess.Popen(ls_ark_files, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out,err = proc.communicate()
    server_files = {}
    for line in out.decode().split("\n"):
        if ip_version == 4:
            m = re.search("([^\/]+-us).team-probing.c",line)
        elif ip_version == 6:
            m = re.search("([^\/]+-us).warts",line)
        if m:
            server = m.groups(1)[0]
            if server not in server_files:
                server_files[server] = set()
            print (server, line)
            server_files[server].add(line.rstrip())
    return server_files

def load_as_org(fname):
    re_format = re.compile("# format:([^|]+)")
    as_country = {}
    with gzip.open(fname) as f:
        org_country = {}
        for line in f:
            line = line.decode()
            m = re_format.search(line)
            if m:
                id = m.group(1)
            if line[0] == '#':
                continue
            values = line.split("|")
            if id == "org_id":
                org_country[values[0]] = values[3]
            else:
                as_country[values[0]] = org_country[values[3]]
    return as_country

main()
