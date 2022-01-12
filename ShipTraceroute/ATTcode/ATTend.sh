# 10
#!/bin/sh
index="crossUS3"
# echo "start" >> /data/local/tmp/log/Verizonlog.txt
WEBHOOK_URL="https://mattermost.caida.org/hooks/8g3huojanjgp7ebj86nnz4ffnw"
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
SIMcard=`getprop | grep gsm.sim.operator.alpha | cut -b 27- | sed 's/\[//' | sed 's/\]//' | sed 's/[[:space:]]//g' | sed 's/\&//g'`
if [ ! -d "/data/local/tmp/${SIMcard}_wartsv6_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_wartsv6_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_sysinfo_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_sysinfo_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_OUTPUT_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_OUTPUT_${index}
fi

# echo "Afteripv4 scamper:"$(date) >> /data/local/tmp/log/Verizonlog.txt

#if [ $SIMcard != "ATT" ]; then
#/data/local/tmp/scamperv6 -O warts -o /data/local/tmp/${SIMcard}_wartsv6_${index}/shipv6_$timestamp.warts -p 100 -c "trace -l 4 -P udp -w 2" /data/local/tmp/${SIMcard}_ipv6.txt >/dev/null 2>/dev/null
#echo "${SIMcard}_scamperv6:"$(date) >> /data/local/tmp/Timetest_${index}.log
#fi
#echo "${SIMcard}scamperv6:" $(date) >> /data/local/tmp/Timetest_${index}.log
# echo "Afteripv6 scamper:"$(date) >> /data/local/tmp/log/Verizonlog.txt
# === OUTPUT RESULTS TO MATTERMOST ===
dumpsys telephony.registry > /data/local/tmp/${SIMcard}_sysinfo_${index}/${timestamp}_sysinfo_${index}
#latlon=`dumpsys location | grep hAcc | sed -n '1p' | sed 's/gps//g' | sed 's/Location\[//g' | sed 's/://g' | sed 's/hAcc.*//g' | sed 's/fused//g' | sed 's/network//g'| sed 's/[[:space:]]//g' | sed 's/passive//g'`
battpct=`dumpsys battery | grep level | cut -c 10-`" percent"
cellid=`dumpsys telephony.registry | grep notifyServiceStateForSubscriber | sed -n '$p' | sed 's/\&//g'`
#signalinfo=`dumpsys telephony.registry | egrep -o "getRilDataRadioTechnology=.*, mCss" | sed -n 1p | sed 's/, mCss//g' | sed 's/getRilDataRadioTechnology=//g' | sed 's/[0-9]//g' | sed 's/(//g' | sed 's/)//g'`

# ipv4=`curl https://ipinfo.io/ip`
serial=`getprop | grep ro.boot.serialno | cut -c 21-`

wartsv4name=`ls /data/local/tmp/${SIMcard}_wartsv4_out_${index} -t | head -n1 | awk '{printf("%s",$0)}' `
wartsize=`du -h /data/local/tmp/${SIMcard}_wartsv4_out_${index}/${wartsv4name} | cut -f1 `

# wartsize=`du -h /data/local/tmp/${SIMcard}_wartsv4/ship_$timestamp.warts | cut -f1`
wartsv6name=`ls /data/local/tmp/${SIMcard}_wartsv6_out_${index} -t | head -n1 | awk '{printf("%s",$0)}' `
wartsizev6=`du -h /data/local/tmp/${SIMcard}_wartsv6_out_${index}/${wartsv6name} | cut -f1 `

wartsv4nameinside=`ls /data/local/tmp/${SIMcard}_wartsv4_${index} -t | head -n1 | awk '{printf("%s",$0)}' `
wartsizeinside=`du -h /data/local/tmp/${SIMcard}_wartsv4_${index}/${wartsv4nameinside} | cut -f1 `
#echo ${wartsizeinside}

wartsv6name_inside=`ls /data/local/tmp/${SIMcard}_wartsv6_${index} -t | head -n1 | awk '{printf("%s",$0)}' `
wartsizev6_inside=`du -h /data/local/tmp/${SIMcard}_wartsv6_${index}/${wartsv6name_inside} | cut -f1 `

wartsgooglename=`ls /data/local/tmp/${SIMcard}_google_warts_${index} -t | head -n1 | awk '{printf("%s",$0)}' `
wartgooglesize=`du -h /data/local/tmp/${SIMcard}_google_warts_${index}/${wartsgooglename} | cut -f1 `

wartsnetflixname=`ls /data/local/tmp/${SIMcard}_Netflix_warts_${index} -t | head -n1 | awk '{printf("%s",$0)}' `
wartnetflixsize=`du -h /data/local/tmp/${SIMcard}_Netflix_warts_${index}/${wartsnetflixname} | cut -f1 `
#hostname=`curl --max-time 5 ipv4.amibehindaproxy.com | grep -A 1 Via | sed 's/<td class="result">//g' | sed 's/<\/td>//g'`
hostnamefile=`ls /data/local/tmp/Proxy_info_${index} -t | head -n 1 | awk '{printf("%s", $0)}' `
hostname=`cat /data/local/tmp/Proxy_info_${index}/${hostnamefile}`
hostnamev6file=`ls /data/local/tmp/Proxy_info_v6_${index} -t | head -n 1 | awk '{printf("%s",$0)}' `
hostnamev6=`cat /data/local/tmp/Proxy_info_v6_${index}/${hostnamev6file}`
echo ${hostname}
echo ${hostnamev6}
temp=$((`dumpsys battery | grep temp | cut -c 15-`/10))
# if [ $SIMcard != "ATT" ]; then
OUTPUT="$SIMcard generated a wart.\nBattery: $battpct\nTemp: $temp C\nCellInfo: $cellid\nproxy name: $hostname\nproxyv6 name: $hostnamev6\nWart timestamp: $timestamp\nWartv4 inside size:$wartsizeinside\nWartv4  size: $wartsize\nWartv6 inside size: $wartsizev6_inside\nWartv6 size: $wartsizev6\nGoogle size: $wartgooglesize\nNetflix size: $wartnetflixsize\nScamper to beamer.caida.org:\n"
# if [ $SIMcard == "ATT" ]; then
#	OUTPUT="$SIMcard generated a wart.\nBattery: $battpct\nTemp: $temp C\nCellInfo: $cellid\nWart timestamp: $timestamp\nWartv4  size: $wartsize\nGoogle size: $wartgooglesize\nNetflix size: $wartnetflixsize\nScamper to beamer.caida.org:\n"
# fi
ATTscampfilenamev4=`ls /data/local/tmp/ATT_sysnetv4_${index} -t | head -n1 |awk '{printf("%s",$0)}' `
ATTscampv4=`cat /data/local/tmp/ATT_sysnetv4_${index}/${ATTscampfilenamev4}`
ATTscampfilenamev6=`ls /data/local/tmp/ATT_sysnetv6_${index} -t | head -n1 |awk '{printf("%s",$0)}' `
ATTscampv6=`cat /data/local/tmp/ATT_sysnetv6_${index}/${ATTscampfilenamev6}`

OUTPUT=$OUTPUT'`'"$ATTscampv4\n"'`'
OUTPUT=$OUTPUT'`'"$ATTscampv6"'`'
# Get Tmobile file info
# Tmobileoutputfilename=`ls /data/local/tmp/Tmobile_OUTPUT_back -t | head -n1 |awk '{printf("%s",$0)}' `
# FirstSIMcard=`sed -n '1p' /data/local/tmp/Tmobile_OUTPUT_back/${Tmobileoutputfilename} | sed 's/ generated a warts.//g'`
# if [ $FirstSIMcard != "ATT" ]; then
# 	while read line
# 	do
# 		Tmobile_OUTPUT=$Tmobile_OUTPUT"$line\n"
# 	done <<< $(cat /data/local/tmp/Tmobile_OUTPUT_back/${Tmobileoutputfilename} | head -n 10)
# else
# 	while read line
# 	do
# 		Tmobile_OUTPUT=$Tmobile_OUTPUT"$line\n"
# 	done <<< $(cat /data/local/tmp/Tmobile_OUTPUT_back/${Tmobileoutputfilename} | head -n 9)
# fi
# Tmobilescampfilenamev4=`ls /data/local/tmp/Tmobile_sysnetv4_back -t | head -n1 |awk '{printf("%s",$0)}' `
# Tmobilescampv4=`cat /data/local/tmp/Tmobile_sysnetv4_back/${Tmobilescampfilenamev4}`
# Tmobile_OUTPUT=$Tmobile_OUTPUT'`'"$Tmobilescampv4\n"'`'
# if [ $FirstSIMcard != "ATT" ]; then
# 	Tmobilescampfilenamev6=`ls /data/local/tmp/Tmobile_sysnetv6_back -t | head -n1 |awk '{printf("%s",$0)}' `
# 	Tmobilescampv6=`cat /data/local/tmp/Tmobile_sysnetv6_back/${Tmobilescampfilenamev6}`
# 	Tmobile_OUTPUT=$Tmobile_OUTPUT'`'"$Tmobilescampv6\n"'`'
# fi

# Get ATT file info
# ATToutputfilename=`ls /data/local/tmp/ATT_OUTPUT_back -t | head -n1 |awk '{printf("%s",$0)}' `
# while read line
# do
# 	ATT_OUTPUT=$ATT_OUTPUT"$line\n"
# done <<< $(cat /data/local/tmp/ATT_OUTPUT_back/${ATToutputfilename} | head -n 9)
# ATTscampfilename=`ls /data/local/tmp/ATT_sysnet_back -t | head -n1 |awk '{printf("%s",$0)}' `
# ATTscamp=`cat /data/local/tmp/ATT_sysnet_back/${ATTscampfilename}`
# ATT_OUTPUT=$ATT_OUTPUT'`'"$ATTscamp\n"'`'

# OUTPUT="$ATT_OUTPUT\n"$OUTPUT
# OUTPUT="$Tmobile_OUTPUT\n"$OUTPUT
# echo "Before uploading"$(date) >> /data/local/tmp/log/Verizonlog.txt
echo $OUTPUT > /data/local/tmp/${SIMcard}_OUTPUT_${index}/OUTPUT_$timestamp.txt
curl --max-time 5 -X POST -d 'payload={"username": "Samsung A71 5G '$serial'", "icon_url": "http://cseweb.ucsd.edu/~schulman/img/box.png", "text":"'"$OUTPUT"'"}' "$WEBHOOK_URL" >> /data/local/tmp/Timetest_${index}.log
#echo "After uploading"$(date) >> /data/local/tmp/log/Verizonlog.txt
echo "${SIMcard}_end:"$(date) >> /data/local/tmp/Timetest_${index}.log