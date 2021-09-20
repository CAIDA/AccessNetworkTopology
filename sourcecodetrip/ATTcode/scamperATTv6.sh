# 4
index="crossUS3"
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
SIMcard=`getprop | grep gsm.sim.operator.alpha | cut -b 27- | sed 's/\[//' | sed 's/\]//' | sed 's/[[:space:]]//g' | sed 's/\&//g'`
if [ ! -d "/data/local/tmp/Verizon_sysnetv4_${index}" ]; then
	mkdir /data/local/tmp/Verizon_sysnetv4_${index}
fi
/data/local/tmp/scamper -O text -p 1000 -c "trace -P icmp" -i 192.172.226.18 2>/dev/null >/data/local/tmp/Verizon_sysnetv4_${index}/ship_$timestamp.txt
echo "${SIMcard}_samplev4:" $(date) >> /data/local/tmp/Timetest_${index}.log
# echo "After ipv4 sample scamper:"$(date) >> /data/local/tmp/log/Verizonlog.txt
# if [ $SIMcard != "ATT" ]; then
# 	/data/local/tmp/scamperv6 -O text -p 1000 -c "trace -f 5 -q 1 -P udp" -i 2001:48d0:101:501:ec4:7aff:fe69:73e2 2>/dev/null >/data/local/tmp/Verizon_sysnetv6/ship_$timestamp.txt
# fi
# echo "Verizonsamplev6:" $(date) >> /data/local/tmp/Timetest.log