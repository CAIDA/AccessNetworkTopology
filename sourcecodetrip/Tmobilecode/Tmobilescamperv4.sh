# 3
index="crossUS4"
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
SIMcard=`getprop | grep gsm.sim.operator.alpha | cut -b 27- | sed 's/\[//' | sed 's/\]//' | sed 's/[[:space:]]//g' | sed 's/\&//g'`
if [ ! -d "/data/local/tmp/${SIMcard}_wartsv4_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_wartsv4_${index}
fi

# Send package to AWS and do the scamper for IPv4 target address.
#/data/local/tmp/client.o >/dev/null 2>/dev/null
#echo "client.o:" $(date) >> /data/local/tmp/Timetest_back.log
/data/local/tmp/scamper -O warts -o /data/local/tmp/${SIMcard}_wartsv4_${index}/ship_$timestamp.warts -p 100 -c "trace -P icmp-paris -w 2" /data/local/tmp/${SIMcard}_ipv4.txt >/dev/null 2>/dev/null
echo "scamperv4:" $(date) >> /data/local/tmp/Timetest_${index}.log