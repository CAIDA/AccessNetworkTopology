# 5
index="SD"
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
SIMcard=`getprop | grep gsm.sim.operator.alpha | cut -b 27- | sed 's/\[//' | sed 's/\]//' | sed 's/[[:space:]]//g' | sed 's/\&//g'`
if [ ! -d "/data/local/tmp/${SIMcard}_wartsv6_${index}" ]; then
	mkdir /data/local/tmp/${SIMcard}_wartsv6_${index}
fi
# scamper for IPv6 target address.
/data/local/tmp/scamperv6 -O warts -o /data/local/tmp/${SIMcard}_wartsv6_${index}/shipv6_$timestamp.warts -p 50 -c "trace -f 4 -P udp -w 2" /data/local/tmp/${SIMcard}_ipv6.txt >/dev/null 2>/dev/null