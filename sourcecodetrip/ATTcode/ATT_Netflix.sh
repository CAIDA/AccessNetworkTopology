# 9
index="crossUS3"
currenttime=`date +"%Y-%m-%d_%H-%M-%S"`
SIMcard=`getprop | grep gsm.sim.operator.alpha | cut -b 27- | sed 's/\[//' | sed 's/\]//' | sed 's/[[:space:]]//g' | sed 's/\&//g'`
if [ ! -d "/data/local/tmp/${SIMcard}_Netflix_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_Netflix_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_Netflix_warts_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_Netflix_warts_${index}
fi
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/local/tmp
timeout 15 curl "https://api.fast.com/netflix/speedtest?https=true&token=YXNkZmFzZGxmbnNkYWZoYXNkZmhrYWxm&urlCount=5" > /data/local/tmp/"${SIMcard}_netflix.txt"
echo $currenttime >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_dns.txt
# Parse url downloaded from Netflix speed test
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f1 | sed "s/\[{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f2 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f3 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f4 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f5 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_dns.txt
# Store them in another tmp file
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f1 | sed "s/\[{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_netflix_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f2 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_netflix_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f3 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_netflix_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f4 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_netflix_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f5 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_netflix_dns.txt
# Extract DNS
echo $currenttime >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_ip.txt
line=$(cat /data/local/tmp/${SIMcard}_netflix_dns.txt | sed -n '1p')
DNS=$(echo $line)
number=$(echo ${DNS:3:1})
# Resolve DNS
#if [ $SIMcard != "ATT" ]; then
if [ $number = "6" ]; then
	#echo "666"
	/data/local/tmp/scamperv6 -O warts -o /data/local/tmp/${SIMcard}_Netflix_ipv6.warts -n 8.8.8.8 -I "host -t AAAA $DNS"
	ip=$(/data/local/tmp/sc_wartsdump /data/local/tmp/${SIMcard}_Netflix_ipv6.warts | grep "IN AAAA" | sed "s/.*IN AAAA //g")
	#echo $ip
	echo $ip >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_ip.txt
	currenttime1=`date +"%Y-%m-%d_%H-%M-%S"`
	/data/local/tmp/scamperv6 -O warts -p 100 -c "trace -q 1 -P udp" -i $ip >/dev/null 2>/dev/null >> /data/local/tmp/${SIMcard}_Netflix_warts_${index}/"${SIMcard}_netflixscamperipv6${currenttime1}.warts"
else
	/data/local/tmp/scamperv6 -O warts -o /data/local/tmp/${SIMcard}_Netflix_ipv4.warts -n 8.8.8.8 -I "host -t A $DNS"
	ip=$(/data/local/tmp/sc_wartsdump /data/local/tmp/${SIMcard}_Netflix_ipv4.warts | grep "IN A" | sed "s/.*IN A //g")
	echo $ip >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_ip.txt
	currenttime1=`date +"%Y-%m-%d_%H-%M-%S"`
	/data/local/tmp/scamper -O warts -p 1000 -c "trace -P icmp" -i $ip >/dev/null 2>/dev/null >> /data/local/tmp/${SIMcard}_Netflix_warts_${index}/"${SIMcard}_netflixscamperipv4${currenttime1}.warts"
fi
	
echo "${SIMcard} Netflix end:"$(date) >> /data/local/tmp/Timetest_${index}.log
#rm /data/local/tmp/${SIMcard}_netflix_dns.txt