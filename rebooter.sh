#!/bin/bash

## Copyright Digitune https://memo.digitune.org/2015/wg1200hp_reboot/

ip_router='192.168.0.xxx'
ip_ping_target='192.168.0.xxx'
admin_email='somebody@example.com'

rebooted=0

while rebooted=0; do
    if /bin/ping -i 2 -c 5 $ip_ping_target; then
        echo "Link is normal."
        sleep 2
        rebooted=0
        continue
    else
        echo "Link seems broken. Converter rebooted."
        output=`curl -v "http://$ip_router/reboot.htm" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: ja,en-US;q=0.8,en;q=0.6' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Connection: keep-alive' --compressed`
        curl -v -o /dev/null "http://$ip_router/aterm.css" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: ja,en-US;q=0.8,en;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' -H 'Accept: text/css,*/*;q=0.1' -H "Referer: http://$ip_router/reboot.htm" -H 'Connection: keep-alive' --compressed
        curl -v -o /dev/null "http://$ip_router/util_gw.js" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: ja,en-US;q=0.8,en;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' -H 'Accept: */*' -H "Referer: http://$ip_router/reboot.htm" -H 'Connection: keep-alive' --compressed
        curl -v -o /dev/null "http://$ip_router/menu-images/h1_back.gif" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: ja,en-US;q=0.8,en;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' -H 'Accept: image/webp,image/*,*/*;q=0.8' -H "Referer: http://$ip_router/aterm.css" -H 'Connection: keep-alive' --compressed

        session_id=`echo "$output" | grep hidden | sed -e 's/.*hidden\" value=\"\([^\"]\+\)\".*/\1/g'`
        echo "sleep 3, session_id=$session_id"
        sleep 3

        curl -v -o /dev/null "http://$ip_router/boafrm/formReboot" -H "Origin: http://$ip_router" -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: ja,en-US;q=0.8,en;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H "Referer: http://$ip_router/reboot.htm" -H 'Connection: keep-alive' --data "SESSION_ID=$session_id&reboot=%BA%C6%B5%AF%C6%B0+" --compressed
        curl -v -o /dev/null "http://$ip_router/menu-images/h1_back.gif" -H 'Accept: image/webp,image/*,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H "Referer: http://$ip_router/boafrm/formReboot" -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' --compressed
        if [ $rebooted -eq 0 ]; then
            echo "30 min sleep...sent an email"
            echo "link seems down? converter rebooted." | /usr/bin/mail -s "converter link seems down?" $admin_email
            sleep 1800
        else
            echo "2 hours sleep...sent an email"
            echo "ping probe seems down?" | /usr/bin/mail -s "ping probe seems down?" $admin_email
            sleep 7200
        fi
        rebooted=1
    fi
done