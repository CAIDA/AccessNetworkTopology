import re

filename = "T-mobile_UCSD_wartsresult_back.txt"
fileresult = "Latency_T-mobile_ucsd_back.txt"

with open(filename) as f:
	stamp = f.readlines()
allset = set()
for line in stamp:
	if line[0] == 'T':
		continue
	else:
		if line[0] == 't':
			continue
		else:
			ip = re.findall(r"\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b",line)
			if ip:
				allset.add(ip[0])
print(allset)
flatency = open(fileresult,"w")
for targetip in allset:
	# print(targetip)
	flatency.write('\n')
	for line in stamp:
		if line[0] == 'T':
			time = re.findall(r'[0-9]{2}:[0-9]{2}:[0-9]{2}',line)
			# print(time[0])
		else:
			if line[0] == 't':
				continue
			else:
				ip = re.findall(r"\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b",line)
				if ip:
					if ip[0] == targetip:
						# print("yes")
						latency = re.findall(r"\s([0-9]*?.[0-9]*?)\sms",line)
						# print(latency)
						flatency.write(ip[0]+" "+latency[0]+" "+time[0]+" "+'\n')



