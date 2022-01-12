# 5
index="crossUS4"
WEBHOOK_URL="https://mattermost.caida.org/hooks/8g3huojanjgp7ebj86nnz4ffnw"
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
SIMcard=`getprop | grep gsm.sim.operator.alpha | cut -b 27- | sed 's/\[//' | sed 's/\]//' | sed 's/[[:space:]]//g' | sed 's/\&//g'`
if [ ! -d "/data/local/tmp/${SIMcard}_wartsv6_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_wartsv6_${index}
fi
if [ ! -d "/data/local/tmp/Tmobile_OUTPUT_${index}" ]; then
	mkdir /data/local/tmp/Tmobile_OUTPUT_${index}
fi
if [ ! -d "/data/local/tmp/${SIMcard}_sysinfo_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_sysinfo_${index}
fi
# scamper for IPv6 target address.
if [ $SIMcard != "ATT" ]; then
	/data/local/tmp/scamperv6 -O warts -o /data/local/tmp/${SIMcard}_wartsv6_${index}/shipv6_$timestamp.warts -p 50 -c "trace -P udp -w 2" /data/local/tmp/${SIMcard}_ipv6.txt >/dev/null 2>/dev/null
fi
echo "scamperv6:" $(date) >> /data/local/tmp/Timetest_${index}.log

dumpsys telephony.registry > /data/local/tmp/${SIMcard}_sysinfo_${index}/${timestamp}_sysinfo_${index}
#latlon=`dumpsys location | grep hAcc | sed -n '1p' | sed 's/gps//g' | sed 's/Location\[//g' | sed 's/://g' | sed 's/hAcc.*//' | sed 's/fused//g' | sed 's/[[:space:]]//g' | sed 's/network//g' | sed 's/passive//g'`
battpct=`dumpsys battery | grep level | cut -c 10-`" percent"
cellid=`dumpsys telephony.registry | grep notifyServiceStateForSubscriber | sed -n '$p' | sed 's/\&//g'`
#signalinfo=`dumpsys telephony.registry | egrep -o "getRilDataRadioTechnology=.*, mCss" | sed -n 1p | sed 's/, mCss//g' | sed 's/getRilDataRadioTechnology=//g' | sed 's/[0-9]//g' | sed 's/(//g' | sed 's/)//g'`

wartsv4name=`ls /data/local/tmp/${SIMcard}_wartsv4_${index} -t | head -n1 | awk '{printf("%s",$0)}' `
wartsize=`du -h /data/local/tmp/${SIMcard}_wartsv4_${index}/${wartsv4name} | cut -f1 `

# wartsize=`du -h /data/local/tmp/${SIMcard}_wartsv4/ship_$timestamp.warts | cut -f1`
if [ $SIMcard != "ATT" ]; then
	wartsizev6=`du -h /data/local/tmp/${SIMcard}_wartsv6_${index}/shipv6_$timestamp.warts | cut -f1`
fi
wartsgooglename=`ls /data/local/tmp/${SIMcard}_google_warts_${index} -t | head -n1 | awk '{printf("%s",$0)}' `
wartgooglesize=`du -h /data/local/tmp/${SIMcard}_google_warts_${index}/${wartsgooglename} | cut -f1 `

wartsnetflixname=`ls /data/local/tmp/${SIMcard}_Netflix_warts_${index} -t | head -n1 | awk '{printf("%s",$0)}' `
wartnetflixsize=`du -h /data/local/tmp/${SIMcard}_Netflix_warts_${index}/${wartsnetflixname} | cut -f1 `

temp=$((`dumpsys battery | grep temp | cut -c 15-`/10))
Tmobilescampfilenamev4=`ls /data/local/tmp/Tmobile_sysnetv4_${index} -t | head -n1 |awk '{printf("%s",$0)}' `
Tmobilescampv4=`cat /data/local/tmp/Tmobile_sysnetv4_${index}/${Tmobilescampfilenamev4}`
if [ $SIMcard != "ATT" ]; then
	OUTPUT="$SIMcard generated a wart.\nBattery: $battpct\nTemp: $temp C\nCellInfo: $cellid\nWart timestamp: $timestamp\nWartv4  size: $wartsize\nWartv6 size: $wartsizev6\nGoogle size: $wartgooglesize\nNetflix size: $wartnetflixsize\nScamper to beamer.caida.org:\n"
	Tmobilescampfilenamev6=`ls /data/local/tmp/Tmobile_sysnetv6_${index} -t | head -n1 |awk '{printf("%s",$0)}' `
	Tmobilescampv6=`cat /data/local/tmp/Tmobile_sysnetv6_${index}/${Tmobilescampfilenamev6}`
	OUTPUT=$OUTPUT'`'"$Tmobilescampv4\n"'`'
	OUTPUT=$OUTPUT'`'"$Tmobilescampv6\n"'`'
else
	OUTPUT="$SIMcard generated a wart.\nBattery: $battpct\nTemp: $temp C\nCellInfo: $cellid\nWart timestamp: $timestamp\nWartv4  size: $wartsize\nGoogle size: $wartgooglesize\nNetflix size: $wartnetflixsize\nScamper to beamer.caida.org:\n"
	OUTPUT=$OUTPUT'`'"$Tmobilescampv4\n"'`'
fi
curl -X POST -d 'payload={"username": "Galaxy Note10+ 5G '$serial'", "icon_url": "http://cseweb.ucsd.edu/~schulman/img/box.png", "text":"'"$OUTPUT"'"}' "$WEBHOOK_URL"
# echo $OUTPUT > /data/local/tmp/Tmobile_OUTPUT_back/OUTPUT_$timestamp.txt
echo "first part end:"$(date) >> /data/local/tmp/Timetest_${index}.log
