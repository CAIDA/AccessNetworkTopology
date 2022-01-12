# 5
index="SD_CO"
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
SIMcard=`getprop | grep gsm.sim.operator.alpha | cut -b 27- | sed 's/\[//' | sed 's/\]//' | sed 's/[[:space:]]//g' | sed 's/\&//g'`
if [ ! -d "/data/local/tmp/Verizon_sysnetv6_${index}" ]; then
	mkdir /data/local/tmp/Verizon_sysnetv6_${index}
fi

if [ $SIMcard != "ATT" ]; then
	/data/local/tmp/scamperv6 -O text -p 1000 -c "trace -q 1 -l 4 -P udp" -i 2001:48d0:101:501:ec4:7aff:fe69:73e2 2>/dev/null >/data/local/tmp/Verizon_sysnetv6_${index}/ship_$timestamp.txt
	echo "${SIMcard}_samplev6:" $(date) >> /data/local/tmp/Timetest_${index}.log
fi
#echo "{SIMcard}_samplev6:" $(date) >> /data/local/tmp/Timetest_${index}.log