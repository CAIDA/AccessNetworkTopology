ip=$(ping -c 1 r3---sn-uhvcpax0n5-xhue.googlevideo.com)
if [ $ip = '\n' ];then
	echo "Null"
	ping6 -c 1 $DNS >> testip.txt
	python T-mobiletrainextractip.py
	ip=$(cat testrefreship.txt)
else
	echo "Not Null"
	ping -c 1 $DNS >> testip.txt
# done
# python T-mobiletrainextractip.py
	cat testip.txt | while read line
	do
		echo $line | egrep -o "from\s.*?:" >> testrefreship.txt
	done

	ipold=$(sed -n '1p' testrefreship.txt)
	ip=$(echo $ipold | sed 's/from//g' | sed 's/://g')
fi
# echo "${ip} !!!"


echo "${ip}!!!"