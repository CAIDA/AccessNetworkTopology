import pyasn
import re
import argparse
import os

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--ip_in", type = str,
                        help = "Input the IP that you want to look up")
    parser.add_argument("--ip_file", type = str, 
    					help = "Input the traceroute file name" )
    return parser.parse_args()

if __name__ == "__main__":
	args = get_args()
	ip = args.ip_in
	filename = args.ip_file
	if ip:
		test = re.findall(r"\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b",ip)
		if test:
			asndb = pyasn.pyasn('ipasn_20190901.dat')
			result=asndb.lookup(ip)
			gethost = "host " + str(ip) + " | awk 'NF{ print $NF }'"
			stream = os.popen(gethost)
			dns = stream.read()
			# print(dns[0:-1])
			getorgname = "whois " + str(ip) + " | grep 'OrgName' | sed -n 1p | sed 's/[[:space:]]//g' | sed 's/OrgName://g'"
			stream = os.popen(getorgname)
			OrgName = stream.read()
		else:
			asndb = pyasn.pyasn('ipv6as.dat')
			result = asndb.lookup(ip)
			gethost = "host " + str(ip) + " | awk 'NF{ print $NF }'"
			stream = os.popen(gethost)
			dns = stream.read()
			getorgname = "whois " + str(ip) + " | grep 'OrgName' | sed -n 1p | sed 's/[[:space:]]//g' | sed 's/OrgName://g'"
			stream = os.popen(getorgname)
			OrgName = stream.read()
		print("IP:" + str(ip) + '\n' + "ASN:" + str(result) + "\n" + "DNS:" + str(dns) + "OrgName:" + str(OrgName))
	if filename:
		with open(filename) as f:
			resultlist = f.readlines()

		tmp = filename.split('.txt')
		newfilename = str(tmp[0]) + '_new.txt'
		fresult = open(newfilename,'w')

		for line in resultlist:
			if line[0] == 's':
				fresult.write(line)
				continue
			else:
				if line[0] == 't':
					fresult.write(line)
					continue
				else:
					files_ip = re.findall(r"\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b",line)
					if files_ip:
						asndb = pyasn.pyasn('ipasn_20190901.dat')
						result=asndb.lookup(files_ip[0])
						gethost = "host " + str(files_ip[0]) + " | awk 'NF{ print $NF }'"
						stream = os.popen(gethost)
						dns = stream.read()
						getorgname = "whois " + str(files_ip[0]) + " | grep 'OrgName' | sed -n 1p | sed 's/[[:space:]]//g' | sed 's/OrgName://g'"
						stream = os.popen(getorgname)
						OrgName = stream.read()
						# dns.split('\n')
						# OrgName.split('\n')
						fresult.write(line[0:-1] + ' ' + "ASN:" + str(result) + ' ' + "DNS:" + str(dns[0:-1]) + ' ' + "OrgName:" + str(OrgName[0:-1]) + '\n')
					else:
						files_ip = re.findall(r"\b(?:(?:[0-9A-Fa-f]{1,4}:){6}(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))|::(?:[0-9A-Fa-f]{1,4}:){5}(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))|(?:[0-9A-Fa-f]{1,4})?::(?:[0-9A-Fa-f]{1,4}:){4}(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))|(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4})?::(?:[0-9A-Fa-f]{1,4}:){3}(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))|(?:(?:[0-9A-Fa-f]{1,4}:){,2}[0-9A-Fa-f]{1,4})?::(?:[0-9A-Fa-f]{1,4}:){2}(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))|(?:(?:[0-9A-Fa-f]{1,4}:){,3}[0-9A-Fa-f]{1,4})?::[0-9A-Fa-f]{1,4}:(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))|(?:(?:[0-9A-Fa-f]{1,4}:){,4}[0-9A-Fa-f]{1,4})?::(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))|(?:(?:[0-9A-Fa-f]{1,4}:){,5}[0-9A-Fa-f]{1,4})?::[0-9A-Fa-f]{1,4}|(?:(?:[0-9A-Fa-f]{1,4}:){,6}[0-9A-Fa-f]{1,4})?::)",line)
						if files_ip:
							asndb = pyasn.pyasn('ipv6as.dat')
							result = asndb.lookup(files_ip[0])
							gethost = "host " + str(files_ip[0]) + " | awk 'NF{ print $NF }'"
							stream = os.popen(gethost)
							dns = stream.read()
							getorgname = "whois " + str(files_ip[0]) + " | grep 'OrgName' | sed -n 1p | sed 's/[[:space:]]//g' | sed 's/OrgName://g'"
							stream = os.popen(getorgname)
							OrgName = stream.read()
							# dns.split('\n')
							# OrgName.split('\n')
							fresult.write(line[0:-1] + ' ' + "ASN:" + str(result) + ' ' + "DNS:" + str(dns[0:-1]) + ' ' + "OrgName:" + str(OrgName[0:-1]) +'\n')
		# print(filename)
    