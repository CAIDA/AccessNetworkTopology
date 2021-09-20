import re

# filename = "T-mobile_netflix.txt"

filename = "testip.txt"
with open(filename) as f:
	netflix = f.readlines()

# sumupTmobilenetflix = open("T-mobile_netflix_sum_up_ip.txt","a")
Tmoblienetflixip = open("testrefreship.txt","w")


for line in netflix:
	# sumupTmobilenetflix.write(line+'\n')
	# print(line[0])
	# print(line[1]+'\n')
	if (line[0] == '1') and (line[1] == '6'):
		# print(line)
		ipes = re.findall(r"from\s(.*?),",line)
	# print(dnses)
		if ipes:
			# print(ipes[0])
			# for ip in ipes:
			Tmoblienetflixip.write(ipes[0]+'\n')
			# sumupTmobilenetflix.write(ipes[0]+'\n')
		# print(dns)
emptyip = open("testip.txt","w")
emptyip.close()
sumupTmobilenetflix.close()
Tmoblienetflixip.close()