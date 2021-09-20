import re

# filename = "T-mobile_netflix.txt"

filename = "ip.txt"
with open(filename) as f:
	netflix = f.readlines()

sumupTmobilenetflix = open("T-mobile_netflix_sum_up_ip.txt","a")
Tmoblienetflixip = open("refreship.txt","w")


for line in netflix:
	# sumupTmobilenetflix.write(line+'\n')
	# print(line[0])
	# print(line[1]+'\n')
	if (line[0] == '1') and (line[1] == '6'):
		# print(line)
		ipes = re.findall(r"from\s(.*?),",line)
		if ipes:
			# print(ipes[0])
			# for ip in ipes:
			Tmoblienetflixip.write(ipes[0]+'\n')
			sumupTmobilenetflix.write(ipes[0]+'\n')
	else:
		if (line[0] == '6') and (line[1] == '4'):
			ipes = re.findall(r"from\s(.*?):",line)
	# print(dnses)
			if ipes:
				# print(ipes[0])
				# for ip in ipes:
				Tmoblienetflixip.write(ipes[0]+'\n')
				sumupTmobilenetflix.write(ipes[0]+'\n')
		# print(dns)
emptyip = open("ip.txt","w")
emptyip.close()
sumupTmobilenetflix.close()
Tmoblienetflixip.close()