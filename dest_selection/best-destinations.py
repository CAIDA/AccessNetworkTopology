#! /usr/bin/env python3
import re
import sys
import time
def main():
    link_dsts = {}
    dst_links = {}
    with open(sys.argv[1]) as f:
        num_links = 0
        for line in f:
            if len(line) < 0 or line[0] == "#":
                continue 
            values = line.rstrip().split(",")
            link = values[0]
            link_dsts[link] = values[1:]
            #print (len(values),len(link_dsts[link]))
            for dst in values[1:]:
                if dst not in dst_links:
                    dst_links[dst] = []
                dst_links[dst].append(link)
            num_links += 1
            #if num_links > 100:
            #    break

        dst_num_links = {}
        for dst,links in dst_links.items():
            dst_num_links[dst] = len(links)

        dsts = list(dst_num_links.keys())
        link_seen = set()
        t = time.time()
        while len(dsts) > 0:
            dst_max_value = -999999999999999
            dst_max= ""
            dst_i = 0
            for i,dst in enumerate(dsts):
                value = dst_num_links[dst]
                #print (">",dst, value)
                if dst_max_value < value:
                    dst_i = i
                    dst_max = dst
                    dst_max_value = value
            dst = dsts.pop()
            if len(dst) > dst_i:
                dsts[dst_i] = dst

            if dst_max_value == 0:
                break

            print(dst_max,dst_max_value)
            if time.time() - t > 10:
                print(dst_max,dst_max_value,len(link_seen),num_links,file=sys.stderr)
                t = time.time()
            for link in dst_links[dst_max]:
                if link not in link_seen:
                    for dst in link_dsts[link]:
                        dst_num_links[dst] -= 1
                    link_seen.add(link)

main()
