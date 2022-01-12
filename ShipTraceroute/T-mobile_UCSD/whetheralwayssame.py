import re

filename = "T-mobile_UCSD_wartsresult_back.txt"
filenameresult = "T-mobile_ucsd_same_back.txt"
with open(filename) as f:
	ucsd = f.readlines()
fcompare = open(filenameresult,"w")

ipinitialset = set()
# ipformerset = {}
# flag = True
for line in ucsd:
	if line[0] == "T":
		continue
	else:
		if line[0] == "t":
			continue
		else:
			ip = re.findall(r"\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b",line)
			if ip:
				# print(ip[0])
				ipinitialset.add(ip[0])
			if line[0] == "1" and line[1] == "6":
				break
print(ipinitialset)

timestamp = ['start']
ipset = set()
for line in ucsd:
	if line[0] == "T":
		differenceset = ipinitialset - ipset
		differenceset1 = ipset - ipinitialset
		fcompare.write(timestamp[0]+":"+"difference:"+str(differenceset)+str(differenceset1)+'\n')
		ipset = set()
		# print(len(differenceset1))
		# if (len(differenceset1) > 3):
		# 	ipinitialset = ipset
		timestamp = re.findall(r"\d{1,2}:\d{1,2}:\d{1,2}",line)
	else:
		if line[0] == "t":
			continue
		else:
			ip = re.findall(r"\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b",line)
			if ip:
				ipset.add(ip[0])



