#!/bin/bash

if [ $# -lt 2 ]; then
  echo "$0 <UPS_TRACKING_NUMBER> <MM WEBHOOK URL>"
  exit
fi

UPS_TRACKING=$1
WEBHOOK_URL=$2

# Find Chrome binary and html2text
if [[ $OSTYPE =~ "darwin" ]]; then
  CHROME='/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'

  HTML2TXT=`which html2text`
  HTML2TXT_HEADER=`head -n1 "$HTML2TXT"`
  if ! [[ $HTML2TXT_HEADER =~ "python" ]]; then
    echo "Error: Incorrect version of html2text installed. I need the python version to parse UPS's HTML4."
    exit
  fi
elif [[ $OSTYPE =~ "linux" ]]; then
  CHROME='google-chrome'
  HTML2TXT=`which html2markdown`
fi

# Check for correct version of html2text

# Run headless chrome to get UPS tracking html
CURR_EVENT=`"$CHROME" --headless --disable-gpu --dump-dom --no-sandbox 'https://wwwapps.ups.com/WebTracking/processInputRequest?TypeOfInquiryNumber=T&InquiryNumber1='$UPS_TRACKING | $HTML2TXT | grep -A4 "Shipment Progress" | tail -n1`
echo $CURR_EVENT

OUTPUT=$CURR_EVENT
curl -X POST -d 'payload={"username": "UPS Tracking ['$UPS_TRACKING']", "icon_url": "https://www.ups.com/assets/resources/images/UPS_logo.svg", "text":"'"$OUTPUT"'"}' "$WEBHOOK_URL"
