import numpy as np
from numpy import genfromtxt
from python_tsp.exact import solve_tsp_dynamic_programming

def get_args():
	parser = argparse.ArgumentParser()
	parser.add_argument("--file", type = str, required = True, help = "Input the raw file name")
	parser.add_argument("--address_file", type = int, required = True, help = "Input the address")
	parser.add_argument("--file_output", type = str, required = True, help = "Input the output file name" )
	return parser.parse_args()

if __name__ == "__main__":
	args = get_args()
	filename = args.file
	address_file = args.address_file
	outputfile = args.file_output

	# distance_matrix = np.array([
	#     [0,  5, 4, 10],
	#     [5,  0, 8,  5],
	#     [4,  8, 0,  3],
	#     [10, 5, 3,  0]
	# ])

	distance_matrix = genfromtxt(file, delimiter=',')
	permutation, distance = solve_tsp_dynamic_programming(distance_matrix)
	with open(address_file) as f:
	      lines = f.readlines()
	fin = open(outputfile,'w')

	for idx in permutation:
	  fin.write(lines[idx])
	print(permutation)