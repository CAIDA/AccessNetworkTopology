import re
filename="20190901.prefix2as"

with open(filename) as f:
	content = f.readlines()

f.close()
fin=open("ipasn_20190901.dat","w")
for line in content:
	if(line[0]!="#"):
		ips=line.split('\t')
		print(ips
			)
		fin.write(ips[0]+'/'+ips[1]+'\t'+ips[2])

fin.close()