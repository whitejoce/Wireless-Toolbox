#!/bin/bash

echo "[+] List:"
sudo iwconfig
read -p "[&] Please select interface : " interface
check=$(sudo iwconfig $interface)
#echo $check
if [ ! -n "$check" ]; then

	echo "[-] This interface no wireless extensions."

else
	read -p '[&] Choose an option[random,newsAP,diyAP]: ' option
	if [ $option == newsAP -o $option == newsap ]; then
		
		echo "[=] Option : newsAP"
		echo "[+]Please wait..."
		IP="news.sina.com.cn"
		testNet=`ping -c 2 $IP | grep "100% packet loss" | wc -l`
		if [ "${testNet}" != 0 ];then
			echo "[-] It seems like can't connect to 'news.sina.com.cn'."
			exit -1
		else
			sudo python code/getnews.py
		fi
	elif [ $option == diyAP -o $option == diyap ]; then
		echo "Not FINISH!"
		#diy file.
	elif [ $option == random ]; then
		echo "[=] Option : random"
	else
		echo " [-] Unknown option: $option"
		exit -1
	fi

	read -p '[!] Change the mac address? [Y/N] ' key
    if [ $key == "Y" -o $key == "y"  ]; then
        sudo ifconfig $interface down
	    sudo macchanger -A $interface
	    sudo ifconfig $interface up
        
    else
        echo -e "\n[-] Don't Change the mac address."
	fi
    
	sudo airmon-ng start $interface

	mon=$(echo `sudo airmon-ng`|grep "phy" |cut -d ' ' -f6)
	echo -e "\n[*] You can use 'sudo airmon-ng stop $mon' to stop."
	
	echo -e "[*] You can use (Need stop the airmon-ng.)\n'sudo ifconfig $interface down && sudo macchanger -p \
$interface && sudo ifconfig $interface up'\n[*] to correct mac address.\n(Need stop the airmon-ng.)"
	echo "[+] Running now(Ctrl+C to stop)..."
	
	if [ $option == newsAP -o $option == newsap ]; then
		 sudo mdk3 $mon b -a -f code/news.txt -s 200
	elif [ $option == diyAP -o $option == diyap ]; then
		 echo "Not FINISH!"
		 sudo mdk3 $mon b -a -f $filename -s 200
	elif [ $option == random ]; then
		 sudo mdk3 $mon b -a -s 200
	fi
	
fi




