# 1
index="SD_CO"
echo "Third part begin: "$(date) >> /data/local/tmp/Timetest_${index}.log
currenttime=`date +"%Y-%m-%d_%H-%M-%S"`
SIMcard=`getprop | grep gsm.sim.operator.alpha | cut -b 27- | sed 's/\[//' | sed 's/\]//' | sed 's/[[:space:]]//g' | sed 's/\&//g'`
if [ ! -d "/data/local/tmp/${SIMcard}_Google_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_Google_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_google_warts_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_google_warts_${index}
fi
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/local/tmp
timeout 15 curl "https://www.youtube.com/watch?v=8G89StDuGe4" | sed -n '33,43p' > /data/local/tmp/"${SIMcard}_google.txt"

# echo "Verizon After curl:" $(date) >> /data/local/tmp/Timetest.log
cat /data/local/tmp/${SIMcard}_google.txt | egrep -o "https:.*googlevideo.com" >> /data/local/tmp/${SIMcard}_google_dns.txt
# echo "Verizon After extract:" $(date) >> /data/local/tmp/Timetest.log
# Extract DNS
DNSold=$(sed -n '1p' /data/local/tmp/${SIMcard}_google_dns.txt)
DNS=$(echo $DNSold | sed 's/https:\\\/\\\///g' | sed 's/\\\/.*).*//g')
echo "$currenttime : $DNS" >> /data/local/tmp/${SIMcard}_Google_${index}/${SIMcard}_google_sum_up_dns.txt
# Resolve DNS
/data/local/tmp/scamperv6 -O warts -o /data/local/tmp/${SIMcard}_Google_ipv4.warts -n 8.8.8.8 -I "host -t A $DNS"
ip=$(/data/local/tmp/sc_wartsdump /data/local/tmp/${SIMcard}_Google_ipv4.warts | grep "IN A" | sed "s/.*IN A //g")
if [ $ip != "" ]; then
	echo "$currenttime:$ip" >> /data/local/tmp/${SIMcard}_Google_${index}/${SIMcard}_google_sum_up_ip.txt
	# echo $ip
	/data/local/tmp/scamper -O warts -c "trace -P Icmp" -i $ip >/dev/null 2>/dev/null >> /data/local/tmp/${SIMcard}_google_warts_${index}/"${SIMcard}_googlescamper${currenttime}.warts"
else
	/data/local/tmp/scamperv6 -O warts -o /data/local/tmp/${SIMcard}_Google_ipv6.warts -n 8.8.8.8 -I "host -t AAAA $DNS"
	ip=$(/data/local/tmp/sc_wartsdump /data/local/tmp/${SIMcard}_Google_ipv6.warts | grep "IN AAAA" | sed "s/.*IN AAAA //g")
	echo "$currenttime:$ip" >> /data/local/tmp/${SIMcard}_Google_${index}/${SIMcard}_google_sum_up_ip.txt
	/data/local/tmp/scamperv6 -O warts -p 100 -c "trace -f 4 -q 2 -P udp" -i $ip >/dev/null 2>/dev/null >> /data/local/tmp/${SIMcard}_google_warts_${index}/"${SIMcard}_googlescamperv6${currenttime}.warts"
fi
echo "${SIMcard} Google end: "$(date) >> /data/local/tmp/Timetest_${index}.log
rm /data/local/tmp/${SIMcard}_google_dns.txt