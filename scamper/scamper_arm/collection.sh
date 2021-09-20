adb shell
cd /data/local/tmp
killall scamper
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.
./scamper -D -d debug.txt -p400 -P12345 > output.scamper;  ./sc_bdrmap -f 4 -O noalias -O noipopts -a 20190901.prefix2as -v verizon-sibling.txt -x 20190910.v4.peering -p12345 -o output.bdrmap.warts >output.bdrmap
