#!/usr/bin/env bash
printf "Checking public proxy IPs\n"
printf "SOCKS5: " 
curl --proxy socks5h://localhost:1080 ifconfig.co
printf "HTTP: "
curl --proxy 127.0.0.1:1081 ifconfig.co
printf "Unproxied public IP: "
curl ifconfig.co
exit
