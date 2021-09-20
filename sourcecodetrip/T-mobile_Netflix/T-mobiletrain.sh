# # Collection data from Jetpack
# #!/bin/bash
# num=0
# # get cookie
# curl -s -c cookies.txt 'http://192.168.1.1/index.html'

# # use cookie to get secToken
# secToken=`curl -s -b cookies.txt 'http://192.168.1.1/index.html' | grep secToken | cut -d " " -f 2 | sed 's/"//g' | sed 's/.$//'`

# # login with sectoken and replace cookies
# curl -v -b cookies.txt -c cookies_loggedin.txt -s -d "token=${secToken}&ok_redirect=%2Findex.html&err_redirect=%2Findex.html&session.password=96750dd8" "http://192.168.1.1/Forms/config"

interfacename='en3'
while true
do
	# Download serverfile from Fast.com
	currenttime=$(date)
	# curl -v -b cookies_loggedin.txt "http://192.168.1.1/api/model.json" -o ./jsonfile/"T-mobile_model_netflix${currenttime}.json"
	curl --dns-interface $interfacename --interface $interfacename "https://api.fast.com/netflix/speedtest?https=true&token=YXNkZmFzZGxmbnNkYWZoYXNkZmhrYWxm&urlCount=5" > "T-mobile_netflix.txt"
	echo "$currenttime" >> sum_up_Tmobile_netflix.txt
	# Extract dns
	python T-mobiletrainextractdns.py
	# Get ip address 
	cat dns.txt | while read line
	do
		DNS=$(echo $line)
		# echo $DNS
		number=$(echo ${DNS:3:1})
		# echo $number
		if [ $number = "6" ]
		then
			# flag=1
			echo "ping6"
			ping6 -c 1 $DNS >> ip.txt
		else
			echo "ping"
			ping -c 1 $DNS >> ip.txt
		fi
	done
	echo "$currenttime" >> T-mobile_netflix_sum_up_ip.txt
	cat ip.txt
	python T-mobiletrainextractip.py
	# Decide to use ipv4 or ipv6 source ip
	preDNS=$(cat dns.txt | sed -n '1p')
	number=$(echo ${preDNS:3:1})
	echo $number
	if [ $number = "6" ]
	then
		srcip=$(ifconfig $interfacename | grep "inet6 " | cut -d ' ' -f 2| sed -n '3p')
		echo $srcip
	else
		srcip=$(ifconfig $interfacename | grep "inet " | cut -d ' ' -f 2)
		echo $srcip
	fi
	# scamp
	cat refreship.txt | while read ip
	do
		currenttime1=$(date)
		scamper -O warts -I "trace -P Icmp -S $srcip $ip" >> ./wartsfile/"T-mobile_netflixscamper${currenttime1}.warts"
	done
	rm ip.txt
	echo "Done with ${num} times"
	num=`expr $num + 1`
done