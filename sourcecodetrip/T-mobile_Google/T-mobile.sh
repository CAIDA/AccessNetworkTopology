# # Collect data from Jetpack
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
	currenttime=$(date)
	# curl -v -b cookies_loggedin.txt "http://192.168.1.1/api/model.json" -o ./jsonfile/"T-mobile_model_google_${currenttime}.json"
	
	# Get dns of Google server
	curl --dns-interface $interfacename --interface $interfacename "https://www.youtube.com/watch?v=8G89StDuGe4" > "T-mobile_google.txt"
	cat T-mobile_google.txt | while read line
	do
		echo $line | egrep -o "https:.*?googlevideo.com" >> dns.txt
	done
	DNSold=$(sed -n '1p' dns.txt)
	DNS=$(echo $DNSold | sed 's/https:\/\///g')
	echo "$currenttime : $DNS" >> T-mobile_google_sum_up_dns.txt

	# Get ip of Google server
	ping -c 1 $DNS >> ip.txt
	cat ip.txt
	python T-mobiletrainextractip.py
	ip=$(cat refreship.txt)
	echo "${ip}!!!"
	echo "$(date)" >> T-mobile_googlescamper.txt

	# scamp
	srcip=$(ifconfig $interfacename | grep "inet " | cut -d ' ' -f 2)
	scamper -O warts -I "trace -P Icmp -S $srcip $ip" >> ./wartsfile/"T-mobile_googlescamper${currenttime}.warts"

	echo "Done with ${num} times"
	num=`expr $num + 1`
	rm ip.txt
	rm refreship.txt
	rm dns.txt
done