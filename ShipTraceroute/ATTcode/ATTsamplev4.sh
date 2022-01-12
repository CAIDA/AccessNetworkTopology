# 3
index="crossUS3"
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
SIMcard=`getprop | grep gsm.sim.operator.alpha | cut -b 27- | sed 's/\[//' | sed 's/\]//' | sed 's/[[:space:]]//g' | sed 's/\&//g'`
if [ ! -d "/data/local/tmp/ATT_sysnetv4_${index}" ]; then
	mkdir /data/local/tmp/ATT_sysnetv4_${index}
fi
/data/local/tmp/scamper -O text -p 1000 -c "trace -P icmp" -i 192.172.226.18 2>/dev/null >/data/local/tmp/ATT_sysnetv4_${index}/ship_$timestamp.txt
/data/local/tmp/scamper -O text -p 1000 -c "trace -P icmp" -i 71.157.16.114

echo "${SIMcard}_samplev4:" $(date) >> /data/local/tmp/Timetest_${index}.log