#!/bin/bash
URL="http://10.10.10.20:8080/channel1.m3u8"
HOST="IPTV-HEADEND"
Z="127.0.0.1"

HTTP=$(curl -s -o /dev/null -m 5 -w "%{http_code}" "$URL")
LM=$(curl -sI -m 5 "$URL" | awk -F': ' 'tolower($1)=="last-modified"{print $2}' | tr -d '\r')
if [ -n "$LM" ]; then
  AGE=$(date -d "$LM" +%s 2>/dev/null)
  NOW=$(date +%s)
  FRESH=$((NOW-AGE))
else
  FRESH=9999
fi

BITRATE=$(ffprobe -v error -timeout 5000000 -select_streams v:0 -show_entries stream=bit_rate -of default=nw=1:nk=1 "$URL" 2>/dev/null)
BITRATE=$(echo "$BITRATE" | tr -d "\r") && BITRATE=${BITRATE:-0}
[ "$BITRATE" = "N/A" ] && BITRATE=0

UP=0
[ "$HTTP" = "200" ] && [ "$FRESH" -lt 15 ] && UP=1

/usr/bin/zabbix_sender -z $Z -s $HOST -k iptv.stream_up -o $UP >/dev/null
/usr/bin/zabbix_sender -z $Z -s $HOST -k iptv.http_code -o $HTTP >/dev/null
/usr/bin/zabbix_sender -z $Z -s $HOST -k iptv.playlist_age -o $FRESH >/dev/null
/usr/bin/zabbix_sender -z $Z -s $HOST -k iptv.bitrate -o $BITRATE >/dev/null
