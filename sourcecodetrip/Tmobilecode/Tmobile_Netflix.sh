# 2
index="crossUS4"
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
# parse the url download from Netflix speedtest
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f1 | sed "s/\[{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f2 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f3 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f4 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f5 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_dns.txt
# Store them into a temp file for future resolution of DNS.
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f1 | sed "s/\[{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_netflix_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f2 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_netflix_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f3 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_netflix_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f4 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_netflix_dns.txt
cat /data/local/tmp/"${SIMcard}_netflix.txt" | cut -d, -f5 | sed "s/{\"url\"\:\"https\:\/\///g" | sed "s/\/speedtest.*//g" >> /data/local/tmp/${SIMcard}_netflix_dns.txt

echo $currenttime >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_ip.txt
line=$(cat /data/local/tmp/${SIMcard}_netflix_dns.txt | sed -n '1p')
# do
DNS=$(echo $line)
# echo $DNS
number=$(echo ${DNS:3:1})
# echo $number
# See if it's IPv6 or IPv4 address and resolve DNS to IP address.
if [ $number = "6" ]; then
	echo "ping6"
	/data/local/tmp/scamperv6 -O warts -o /data/local/tmp/${SIMcard}_Netflix_ipv6.warts -n 8.8.8.8 -I "host -t AAAA $DNS"
	ip=$(/data/local/tmp/sc_wartsdump /data/local/tmp/${SIMcard}_Netflix_ipv6.warts | grep "IN AAAA" | sed "s/.*IN AAAA //g")
	echo $ip >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_ip.txt
	currenttime1=`date +"%Y-%m-%d_%H-%M-%S"`
	/data/local/tmp/scamperv6 -O warts -p 100 -c "trace -f 4 -q 2 -P udp" -i $ip >/dev/null 2>/dev/null >> /data/local/tmp/${SIMcard}_Netflix_warts_${index}/"${SIMcard}_netflixscamperv6${currenttime1}.warts"
else
	echo "ping"
	/data/local/tmp/scamperv6 -O warts -o /data/local/tmp/${SIMcard}_Netflix_ipv4.warts -n 8.8.8.8 -I "host -t A $DNS"
	ip=$(/data/local/tmp/sc_wartsdump /data/local/tmp/${SIMcard}_Netflix_ipv4.warts | grep "IN A" | sed "s/.*IN A //g")
	echo $ip >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_ip.txt
	currenttime1=`date +"%Y-%m-%d_%H-%M-%S"`
	/data/local/tmp/scamper -O warts -p 1000 -c "trace -P icmp" -i $ip >/dev/null 2>/dev/null >> /data/local/tmp/${SIMcard}_Netflix_warts_${index}/"${SIMcard}_netflixscamperv4${currenttime1}.warts"
fi
echo "First part scamper Netflix end:"$(date) >> /data/local/tmp/Timetest_${index}.log
# done
rm /data/local/tmp/${SIMcard}_netflix_dns.txt