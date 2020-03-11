#!/bin/bash
sudo ifconfig
read -p "[!] Select the Interface to use?[Y/N]" port
sudo brctl addbr Wifi-Bridge
sudo brctl addif Wifi-Bridge eth0
sudo brctl addif Wifi-Bridge at0
sudo ifconfig $port 0.0.0.0 up
sudo ifconfig at0 0.0.0.0 up
sudo echo 1 > /proc/sys/net/ipv4/ip_forward
sudo ifconfig Wifi-Bridge up
echo "Please chaeck if there is any error message(Existing information can be ignored)."
echo "[+] Running now...(Use 'Ctrl+C' to stop the air.)"