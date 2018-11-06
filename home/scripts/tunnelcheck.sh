#!/usr/bin/env bash
printf "Checking public IP @ $(date) \n"
printf "%-10s : %-30s" "Local" "`ip addr show "$1" | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`"
printf "%-10s : %-30s" "Gateway" "`ip route show dev "$1" | fgrep default | sed 's/default via //' | awk '{print $2}'`"
printf "%-10s : %-30s" "SOCKS" "`curl -s --proxy socks5h://localhost:1080 ifconfig.co`"
printf "%-10s : %-30s" "HTTP" "`curl -s --proxy 127.0.0.1:1081 ifconfig.co`"
printf "%-10s : %-30s" "No Proxy" "`curl -s ifconfig.co`"
exit
