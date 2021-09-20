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
	# curl -v -b cookies_loggedin.txt "http://192.168.1.1/api/model.json" -o ./jsonfile/"T-mobile_model_ucsd_${currenttime}.json"
	
	# Get UCSD server ip 
	ping -c 1 login.eng.ucsd.edu >> ip.txt
	cat ip.txt | while read line
	do
		echo $line | egrep -o "from\s.*?:" >> refreship.txt
	done	
	ipold=$(sed -n '1p' refreship.txt)
	ip=$(echo $ipold | sed 's/from//g' | sed 's/://g')
	echo "${ip} !!!"
	echo "$currenttime:$ip" >> T-mobile_UCSD_sum_up_ip.txt
	
	# scamp
	srcip=$(ifconfig $interfacename | grep "inet " | cut -d ' ' -f 2)
	scamper -O warts -I "trace -P Icmp -S $srcip $ip" >> ./wartsfile/"T-mobile_ucsdscamper${currenttime}.warts"
	echo "Done with ${num} times"
	num=`expr $num + 1`
	rm ip.txt
	rm refreship.txt
done