index="test"
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
WEBHOOK_URL="https://mattermost.caida.org/hooks/8g3huojanjgp7ebj86nnz4ffnw"
SIMcard=`getprop | grep gsm.sim.operator.alpha | cut -b 27- | sed 's/\[//' | sed 's/\]//' | sed 's/[[:space:]]//g' | sed 's/\&//g'`
if [ ! -d "/data/local/tmp/${SIMcard}_wartsv4_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_wartsv4_${index}
fi
if [ ! -d "/data/local/tmp/Verizon_sysnetv4_${index}" ]; then
	mkdir /data/local/tmp/Verizon_sysnetv4_${index}
fi
if [ ! -d "/data/local/tmp/Verizon_sysnetv6_${index}" ]; then
	mkdir /data/local/tmp/Verizon_sysnetv6_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_Google_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_Google_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_google_warts_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_google_warts_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_Netflix_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_Netflix_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_Netflix_warts_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_Netflix_warts_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_wartsv6_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_wartsv6_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_sysinfo_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_sysinfo_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_OUTPUT_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_OUTPUT_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_VZW_wartsv4_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_VZW_wartsv4_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_VZW_wartsv6_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_VZW_wartsv6_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_Latencyv4_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_Latencyv4_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_Latencyv6_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_Latencyv6_${index}
fi
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/local/tmp
am start -n eu.thedarken.wldonate/.main.ui.MainActivity
# Inspect TAC:
Tac=`cat /data/local/tmp/formerTac.txt`
fTac=`cat /data/local/tmp/formerTac.txt`
pingresult=''
num=0
while [ "$Tac" -eq "$fTac" -o -z "$pingresult" ]
do
	sleep 10
	num=`expr $num + 1`
	fTac=$Tac
	Tac=`dumpsys telephony.registry | grep notifyServiceStateForSubscriber | sed -n '$p' | sed 's/\&//g' | sed 's/.*mTac=//' | sed 's/ mEarfcn.*//'`
	flag=`dumpsys telephony.registry | grep notifyServiceStateForSubscriber | sed -n '$p' | sed 's/\&//g' | grep -o 'mTac'`
	if [ -z "$flag" ]
	then
		Tac=`dumpsys telephony.registry | grep notifyServiceStateForSubscriber | sed -n '$p' | sed 's/\&//g' | sed 's/.*mLac=//' | sed 's/ mCid.*//'`
		flag=`dumpsys telephony.registry | grep notifyServiceStateForSubscriber | sed -n '$p' | sed 's/\&//g' | grep -o 'mLac'`
	fi
	if [ -z "$flag" ]
	then
		Tac=`cat /data/local/tmp/formerTac.txt`
	fi
	echo $Tac > /data/local/tmp/formerTac.txt
	echo $(date)":$Tac" >> /data/local/tmp/looplog.log
	pingresult=`ping -c 1 8.8.8.8 | grep 'icmp_seq'`
	if [ $num -eq 200 ]
	then
		break
	fi
done
echo $(date)":start" >> /data/local/tmp/looplog.log
# scamper full ipv4 list
/data/local/tmp/scamper -O warts -o /data/local/tmp/${SIMcard}_wartsv4_${index}/ship_$timestamp.warts -p 500 -c "trace -P icmp-paris -w 2" /data/local/tmp/${SIMcard}_tmp_ipv4.txt >/dev/null 2>/dev/null
echo "${SIMcard}_scamperv4:" $(date) >> /data/local/tmp/Timetest_${index}.log
# samplev4 scamper
/data/local/tmp/scamper -O text -p 1000 -c "trace -P icmp" -i 192.172.226.18 2>/dev/null >/data/local/tmp/Verizon_sysnetv4_${index}/ship_$timestamp.txt
echo "${SIMcard}_samplev4:" $(date) >> /data/local/tmp/Timetest_${index}.log
# samplev6 scamper
/data/local/tmp/scamperv6 -O text -p 1000 -c "trace -q 1 -l 4 -P udp" -i 2001:48d0:101:501:ec4:7aff:fe69:73e2 2>/dev/null >/data/local/tmp/Verizon_sysnetv6_${index}/ship_$timestamp.txt
echo "${SIMcard}_samplev6:" $(date) >> /data/local/tmp/Timetest_${index}.log
# scamper VZW inside IP
sleep 20
/data/local/tmp/scamper -O warts -o /data/local/tmp/${SIMcard}_VZW_wartsv4_${index}/ship_$timestamp.warts -p 500 -c "trace -P icmp-paris -w 2" /data/local/tmp/VZW_ipv4.txt >/dev/null 2>/dev/null
echo "VZW_inside_ipv4:" $(date) >> /data/local/tmp/Timetest_${index}.log
# scamper VZWv6 inside IP
/data/local/tmp/scamperv6 -O warts -o /data/local/tmp/${SIMcard}_VZW_wartsv6_${index}/ship_$timestamp.warts -p 500 -c "trace -P icmp-paris -w 2" /data/local/tmp/VZW_ipv6.txt >/dev/null 2>/dev/null
echo "VZW_inside_ipv6:" $(date) >> /data/local/tmp/Timetest_${index}.log
# Latency to each IP
ping -c 10 192.172.226.18 >> /data/local/tmp/${SIMcard}_Latencyv4_${index}/ship_$timestamp.warts
ping6 -c 10 2001:48d0:101:501:ec4:7aff:fe69:73e2 >> /data/local/tmp/${SIMcard}_Latencyv6_${index}/ship_$timestamp.warts

echo "Latency_test:" $(date) >> /data/local/tmp/Timetest_${index}.log
# Verizon2Google
timeout 15 curl "https://www.youtube.com/watch?v=8G89StDuGe4" | sed -n '33,43p' > /data/local/tmp/"${SIMcard}_google.txt"
cat /data/local/tmp/${SIMcard}_google.txt | egrep -o "https:.*googlevideo.com" >> /data/local/tmp/${SIMcard}_google_dns.txt
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
# Verizon2Netflix
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
	/data/local/tmp/scamperv6 -O warts -o /data/local/tmp/${SIMcard}_Netflix_ipv6.warts -n 8.8.8.8 -I "host -t AAAA $DNS"
	ip=$(/data/local/tmp/sc_wartsdump /data/local/tmp/${SIMcard}_Netflix_ipv6.warts | grep "IN AAAA" | sed "s/.*IN AAAA //g")
	#echo $ip
	echo $ip >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_ip.txt
	currenttime1=`date +"%Y-%m-%d_%H-%M-%S"`
	/data/local/tmp/scamperv6 -O warts -p 100 -c "trace -f 5 -q 1 -P udp" -i $ip >/dev/null 2>/dev/null >> /data/local/tmp/${SIMcard}_Netflix_warts_second/"${SIMcard}_netflixscamperipv6${currenttime1}.warts"
else
	/data/local/tmp/scamperv6 -O warts -o /data/local/tmp/${SIMcard}_Netflix_ipv4.warts -n 8.8.8.8 -I "host -t A $DNS"
	ip=$(/data/local/tmp/sc_wartsdump /data/local/tmp/${SIMcard}_Netflix_ipv4.warts | grep "IN A" | sed "s/.*IN A //g")
	echo $ip >> /data/local/tmp/${SIMcard}_Netflix_${index}/${SIMcard}_netflix_sum_up_ip.txt
	currenttime1=`date +"%Y-%m-%d_%H-%M-%S"`
	/data/local/tmp/scamper -O warts -p 1000 -c "trace -P icmp" -i $ip >/dev/null 2>/dev/null >> /data/local/tmp/${SIMcard}_Netflix_warts_${index}/"${SIMcard}_netflixscamperipv4${currenttime1}.warts"
fi
echo "${SIMcard} Netflix end:"$(date) >> /data/local/tmp/Timetest_${index}.log
rm /data/local/tmp/${SIMcard}_netflix_dns.txt
# scamper full ipv6 list
/data/local/tmp/scamperv6 -O warts -o /data/local/tmp/${SIMcard}_wartsv6_${index}/shipv6_$timestamp.warts -p 100 -c "trace -l 4 -P udp -w 2" /data/local/tmp/${SIMcard}_tmp_ipv6.txt >/dev/null 2>/dev/null
echo "${SIMcard}_scamperv6:"$(date) >> /data/local/tmp/Timetest_${index}.log
# Output to Mattermost
dumpsys telephony.registry > /data/local/tmp/${SIMcard}_sysinfo_${index}/${timestamp}_sysinfo_${index}
#latlon=`dumpsys location | grep hAcc | sed -n '1p' | sed 's/gps//g' | sed 's/Location\[//g' | sed 's/://g' | sed 's/hAcc.*//g' | sed 's/fused//g' | sed 's/network//g'| sed 's/[[:space:]]//g' | sed 's/passive//g'`
battpct=`dumpsys battery | grep level | cut -c 10-`" percent"
cellid=`dumpsys telephony.registry | grep notifyServiceStateForSubscriber | sed -n '$p' | sed 's/\&//g'`
#signalinfo=`dumpsys telephony.registry | egrep -o "getRilDataRadioTechnology=.*, mCss" | sed -n 1p | sed 's/, mCss//g' | sed 's/getRilDataRadioTechnology=//g' | sed 's/[0-9]//g' | sed 's/(//g' | sed 's/)//g'`

# ipv4=`curl https://ipinfo.io/ip`
serial=`getprop | grep ro.boot.serialno | cut -c 21-`

wartsv4name=`ls /data/local/tmp/${SIMcard}_wartsv4_${index} -t | head -n1 | awk '{printf("%s",$0)}' `
wartsize=`du -h /data/local/tmp/${SIMcard}_wartsv4_${index}/${wartsv4name} | cut -f1 `

# wartsize=`du -h /data/local/tmp/${SIMcard}_wartsv4/ship_$timestamp.warts | cut -f1`
	# wartsv6name=`ls /data/local/tmp/${SIMcard}_wartsv6 -t | head -n1 | awk '{printf("%s",$0)}' `
wartsizev6=`du -h /data/local/tmp/${SIMcard}_wartsv6_${index}/shipv6_$timestamp.warts | cut -f1 `

wartsgooglename=`ls /data/local/tmp/${SIMcard}_google_warts_${index} -t | head -n1 | awk '{printf("%s",$0)}' `
wartgooglesize=`du -h /data/local/tmp/${SIMcard}_google_warts_${index}/${wartsgooglename} | cut -f1 `

wartsnetflixname=`ls /data/local/tmp/${SIMcard}_Netflix_warts_${index} -t | head -n1 | awk '{printf("%s",$0)}' `
wartnetflixsize=`du -h /data/local/tmp/${SIMcard}_Netflix_warts_${index}/${wartsnetflixname} | cut -f1 `

temp=$((`dumpsys battery | grep temp | cut -c 15-`/10))
OUTPUT="$SIMcard generated a wart.\nBattery: $battpct\nTemp: $temp C\nCellInfo: $cellid\nWart timestamp: $timestamp\nWartv4  size: $wartsize\nWartv6 size: $wartsizev6\nGoogle size: $wartgooglesize\nNetflix size: $wartnetflixsize\nScamper to beamer.caida.org:\n"
Verizonscampfilenamev4=`ls /data/local/tmp/Verizon_sysnetv4_${index} -t | head -n1 |awk '{printf("%s",$0)}' `
Verizonscampv4=`cat /data/local/tmp/Verizon_sysnetv4_${index}/${Verizonscampfilenamev4}`
Verizonscampfilenamev6=`ls /data/local/tmp/Verizon_sysnetv6_${index} -t | head -n1 |awk '{printf("%s",$0)}' `
Verizonscampv6=`cat /data/local/tmp/Verizon_sysnetv6_${index}/${Verizonscampfilenamev6}`

OUTPUT=$OUTPUT'`'"$Verizonscampv4\n"'`'
OUTPUT=$OUTPUT'`'"$Verizonscampv6"'`'
echo $OUTPUT > /data/local/tmp/${SIMcard}_OUTPUT_${index}/OUTPUT_$timestamp.txt
echo "Start uploading"$(date) >> /data/local/tmp/Timetest_${index}.log
timeout 15 curl -X POST -d 'payload={"username": "A71+ 5G '$serial'", "icon_url": "http://cseweb.ucsd.edu/~schulman/img/box.png", "text":"'"$OUTPUT"'"}' "$WEBHOOK_URL" >> /data/local/tmp/Timetest_${index}.log
echo "${SIMcard}_end:"$(date) >> /data/local/tmp/Timetest_${index}.log
am force-stop eu.thedarken.wldonate