# 1
index="crossUS4"
echo "First part start:"$(date) >> Timetest_${index}.log
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
SIMcard=`getprop | grep gsm.sim.operator.alpha | cut -b 27- | sed 's/\[//' | sed 's/\]//' | sed 's/[[:space:]]//g' | sed 's/\&//g'`
if [ ! -d "/data/local/tmp/Tmobile_sysnetv6_${index}" ]; then
	mkdir /data/local/tmp/Tmobile_sysnetv6_${index}
fi
if [ ! -d "/data/local/tmp/Tmobile_sysnetv4_${index}" ]; then
	mkdir /data/local/tmp/Tmobile_sysnetv4_${index}
fi
# Traceroute to CAIDA server including IPv4 and IPv6 address.
/data/local/tmp/scamper -O text -p 1000 -c "trace -P icmp" -i 192.172.226.18 2>/dev/null > /data/local/tmp/Tmobile_sysnetv4_${index}/ship_$timestamp.txt
echo "samplev4:" $(date) >> /data/local/tmp/Timetest_${index}.log
if [ $SIMcard != "ATT" ]; then
	/data/local/tmp/scamperv6 -O text -p 1000 -c "trace -q 1 -P udp" -i 2001:48d0:101:501:ec4:7aff:fe69:73e2 2>/dev/null > /data/local/tmp/Tmobile_sysnetv6_${index}/ship_$timestamp.txt
fi
echo "samplev6:" $(date) >> /data/local/tmp/Timetest_${index}.log