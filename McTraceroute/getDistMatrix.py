import numpy as np
import re
import argparse
import os

def get_args():
	parser = argparse.ArgumentParser()
	parser.add_argument("--file", type = str, required = True, help = "Input the raw file name")
	parser.add_argument("--matrix_size", type = int, required = True, help = "Input the matrix size")
	parser.add_argument("--file_output", type = str, required = True, help = "Input the output file name" )
	parser.add_argument("--file_error", type = str, required = True, help = "Input error file")
	return parser.parse_args()

if __name__ == "__main__":
	args = get_args()
	filename = args.file
	matrix_size = args.matrix_size
	outputfile = args.file_output
	errorfile = args.file_error

	with open(filename) as f:
		lines = f.readlines()

	fin = open(outputfile,'w')
	ferr = open(errorfile,'w')
	matrix = np.zeros((matrix_size,matrix_size))
	# print(matrix)
	
	i = 0
	for origin in lines:
		j = 0
		origin = origin.split('\n')[0]
		while j <= i :
			matrix[i,j] = matrix[j,i]
			j = j + 1
		k = j
		for dest in lines[k:]:
			dest = dest.split('\n')[0]
			getdist = "curl -L -X GET 'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=" + dest + "&origins=" + origin + "&key=[your key]' | grep 'text' | sed -n 1p | sed 's/.*text" + '" : "' + "'//g | sed 's/ km" + '",//g' + "'"
			# print(getdist)
			stream = os.popen(getdist)
			distduration = stream.read().split('\n')[0]
			# print(float(distduration))
			try:
	 			matrix[i,j] = float(distduration)
	 		except:
	 			ferr.write(getdist + '\n')
 			j = j + 1
 		i = i + 1
 	# print(matrix)
 	np.savetxt(outputfile,matrix, delimiter=',')
