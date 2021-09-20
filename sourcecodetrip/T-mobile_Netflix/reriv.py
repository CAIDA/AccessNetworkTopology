import re

filename = "sum_up_Tmobile_netflix.txt"
filenameresult = "T-mobile_netflix_ord_back.txt"
with open(filename) as f:
	netflix = f.readlines()
fcompare = open(filenameresult,"w")
domainset = set()
domaininitialset = set()
# trylist=['lax009' , ]

# for line in netflix:
# 	if line[0] == "S":
# 		continue
# 	else:
# 		# print(line)
# 		domains = re.findall(r"https://(.*?)/",line)
# 		if domains:
# 			# print(domain)
# 			for domain in domains:
# 				select = re.findall(r"sna",domain)
# 				if select:
# 					domaininitialset.add(domain)
# 		break

# result=[i for i in domains + trylist if i not in domains or i not in trylist]
# print(result)
timestamp = ['start']
for line in netflix:
	if line[0] == "S":
		# differenceset = domaininitialset - domainset
		# differenceset1 = domainset - domaininitialset
		# fcompare.write(timestamp[0]+":"+"difference:"+str(differenceset)+str(differenceset1)+'\n')
		
		# # print(len(differenceset1))
		# if (len(differenceset1) >= 1):
		# 	domaininitialset = domainset
		# domainset = set()
		timestamp = re.findall(r"\d{1,2}:\d{1,2}:\d{1,2}",line)
	else:
		domains = re.findall(r"https://(.*?)/",line)
		if domains:
			# print(domain)
			for domain in domains:
				select = re.findall(r"ord",domain)
				if select:
					fcompare.write(timestamp[0]+":"+domain+'\n')

