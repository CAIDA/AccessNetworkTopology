import re

# filename = "T-mobile_netflix.txt"
filename = "T-mobile_netflix.txt"
with open(filename) as f:
	netflix = f.readlines()

sumupTmobilenetflix = open("sum_up_Tmobile_netflix.txt","a")
Tmoblienetflixdns = open("dns.txt","w")

for line in netflix:
	sumupTmobilenetflix.write(line+'\n')
	# print(line)
	dnses = re.findall("https://(.*?)/",line)
	# print(dnses)
	for dns in dnses:
		Tmoblienetflixdns.write(dns+'\n')
		# print(dns)

sumupTmobilenetflix.close()
Tmoblienetflixdns.close()