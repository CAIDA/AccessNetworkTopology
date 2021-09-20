#!/bin/sh
WEBHOOK_URL="https://mattermost.caida.org/hooks/8g3huojanjgp7ebj86nnz4ffnw"
timestamp=`date +"%Y-%m-%d_%H-%M-%S"`
McLocation=$1
# echo $McLocation 

/data/local/tmp/scamper -O warts -o /data/local/tmp/ATTMcTraceroute/sndg_${McLocation}_agg_CO_result_${timestamp}.warts -p 200 -c "trace -P icmp-paris" /data/local/tmp/ATT_sndg_agg_CO_ip_list.txt >/dev/null 2>/dev/null
/data/local/tmp/scamper -O warts -o /data/local/tmp/ATTMcTraceroute/sndg_${McLocation}_end_CO_result_${timestamp}.warts -p 200 -c "trace -P icmp-paris" /data/local/tmp/ATT_sndg_end_CO_ip_list.txt >/dev/null 2>/dev/null
/data/local/tmp/scamper -O text -o /data/local/tmp/ATTMcTraceroute/sndg_${McLocation}_sample_trace_result_${timestamp}.txt -p 100 -c "trace -P icmp-paris" -i 192.172.226.18 >/dev/null 2>/dev/null
/data/local/tmp/scamper -O text -o /data/local/tmp/ATTMcTraceroute/sndg_${McLocation}_end_co_sample_trace_result_${timestamp}.txt -p 100 -c "trace -P icmp-paris" -i 99.174.24.13 >/dev/null 2>/dev/null
/data/local/tmp/scamperv6 -O text -o /data/local/tmp/ATTMcTraceroute/sndg_${McLocation}_sample_trace_result_v6_${timestamp}.txt -p 100 -c "trace -P icmp-paris" -i 2001:48d0:101:501:ec4:7aff:fe69:73e2 >/dev/null 2>/dev/null
# === OUTPUT RESULTS TO MATTERMOST ===

cellid=`dumpsys telephony.registry | grep notifyServiceStateForSubscriber | sed -n '$p' | sed 's/\&//g'`
wart_end_CO_size=`du -h /data/local/tmp/ATTMcTraceroute/sndg_${McLocation}_end_CO_result_${timestamp}.warts | cut -f1 `
wart_agg_CO_size=`du -h /data/local/tmp/ATTMcTraceroute/sndg_${McLocation}_agg_CO_result_${timestamp}.warts | cut -f1 `
OUTPUT="I'm ATT at $McLocation\n Cellinfo: $cellid\n Wart timestamp: $timestamp\n The size of end CO file:$wart_end_CO_size\n The size of agg CO file:$wart_agg_CO_size\n"
sampleresult=`cat /data/local/tmp/ATTMcTraceroute/sndg_${McLocation}_sample_trace_result_${timestamp}.txt`
sampleresultv6=`cat /data/local/tmp/ATTMcTraceroute/sndg_${McLocation}_sample_trace_result_v6_${timestamp}.txt`
sampleendco=`cat /data/local/tmp/ATTMcTraceroute/sndg_${McLocation}_end_co_sample_trace_result_${timestamp}.txt`
OUTPUT=$OUTPUT'`'"$sampleresult\n"'`'
OUTPUT=$OUTPUT'`'"$sampleendco\n"'`'
OUTPUT=$OUTPUT'`'"$sampleresultv6\n"'`'
timeout 15 curl -X POST -d 'payload={"username": "Galaxy A71 5G '$serial'", "icon_url": "http://cseweb.ucsd.edu/~schulman/img/box.png", "text":"'"$OUTPUT"'"}' "$WEBHOOK_URL"