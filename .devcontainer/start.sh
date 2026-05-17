#!/bin/bash
sudo /usr/local/bin/xray run -c /etc/xray/g2ray.json &>/tmp/xray.log &
sleep 2
show-link.sh
echo "[g2ray] Keep-alive active..."
while true; do sleep 300; echo "[$(date '+%H:%M')] alive" >>/tmp/keepalive.log; done