# McTraceroute

## Overview
- To understand ISP's regional access network topology, basically we are using Traceroute to reveal the hidden topology. You should have a selected list of targets to do traceroute to and find enough vantage points to help uncover the topology. The idea of McTraceroute is for you to set up a scripts, going through enough fast food restaurants in a region, connecting to their network and do scripts. For more details, please refer to the [paper](https://dl.acm.org/doi/10.1145/3487552.3487812)

## Usage
- First, find the target restaurant address. Use `python getDistMatrix --file [restaruant address list] --matrix_size [Total number of restaruant] --file_output [output matrix] --file_error [possible error address]`

- Second, use `python TSP.py --file [output matrix from the former script] --address_file [restaruant address list] --file_output [route you are going to take]`

- At last, go through each restaurant and connect to their Wi-Fi and run `McTrarceroute.sh [restaurant name]`