#!/bin/bash
clear; set -u

# -------------------------------
# Router settings
# -------------------------------
user='admin'
password=''
ip_router='192.168.0.1'

# -------------------------------
# Functions
# -------------------------------

function is_ip_up () {
    result=1
    ping -c 3 -t 3 -s 32 $1 > /dev/null;
    if [ $? -eq 0 ]; then
        #success
        result=0
    fi
    return $result
}

# -------------------------------
# Begin
# -------------------------------

echo "Running script to reboot router at ${ip_router}"

url_base="http://$user:$password@$ip_router"

if is_ip_up $ip_router; then
    echo "Router is up. Fetching files..."
else
    echo "Router is down."
    exit 1
fi

html_reboot=`curl -s "$url_base/reboot.htm" --compressed`

session_id=`echo "$html_reboot" \
    | grep hidden \
    | sed -e 's/.*hidden\" value=\"\([^\"]\+\)\".*/\1/g' \
    | grep -o '[0-9a-z]\{32\}'`

echo "SESSION_ID is: $session_id"
sleep 1

html_result=`curl -s "$url_base/boafrm/formReboot" \
    -H "Origin: $url_base" \
    -H "Referer: $url_base/reboot.htm" \
    --data "SESSION_ID=$session_id&reboot=%BA%C6%B5%AF%C6%B0+" \
    --compressed`

while is_ip_up $ip_router; do
    echo -en "\rShutting down router..."
    sleep 1
done

echo; echo "Now rebooting..."

while ! is_ip_up $ip_router; do
    echo -en "\rPinging... router is down"
    sleep 1
done

echo; echo "Router is up."
echo "Router rebooted."

exit 0
