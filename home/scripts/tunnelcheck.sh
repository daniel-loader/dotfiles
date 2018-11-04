#!/usr/bin/env bash
printf "Checking public IP\n"
printf "%-15s" "Local"
ip addr show wifi0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1
printf "%-15s" "Gateway"
ip route show dev wifi0 | fgrep default | sed 's/default via //' | awk '{print $2}'
printf "%-15s" "SOCKS" 
curl --proxy socks5h://localhost:1080 ifconfig.co
printf "%-15s" "HTTP"
curl --proxy 127.0.0.1:1081 ifconfig.co
printf "%-15s" "No Proxy"
curl ifconfig.co
exit
