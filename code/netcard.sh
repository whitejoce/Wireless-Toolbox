#!/bin/bash

echo""
echo "[+] 列出无线网卡:"
echo ""
sudo iwconfig
read -p "[&] 请选择无线网卡 : " interface
check=$(sudo iwconfig $interface)
#echo $check
if [ ! -n "$check" ]; then

	echo "[-] 此接口没有无线功能"
	exit 0

else
	while :
	do
		mcheck=$(sudo iwconfig $interface|grep "Mode:" |cut -d ':' -f2|cut -d ' ' -f1)
		echo "-------------------------------------------\
----------------------------------"
		echo -e "\n 选项:"
		echo " [1] 更换MAC地址"
		echo " [2] 切换回原MAC地址"
		echo " [3] 切换信道"
		if [ "${mcheck}" == "Monitor"  ]; then
			 echo " [4] 退出监听模式"
		else
			 echo " [4] 切换到监听模式"
		fi
		echo -e "\033[31m [9] 退出 \033[0m"
		echo ""
		read -p ' [&] 选择要执行的功能: ' o1
		echo "-------------------------------------------\
----------------------------------"
		if [ ${o1} == 1 ]; then
			 while :
			 do
				 echo "-------------------------------------------\
----------------------------------"
		 		 echo -e "\n 选项:"
				 echo " [1] 完全随机MAC"
				 echo " [2] 相同厂家MAC"
				 echo " [3] 随机厂家MAC"
				 echo -e "\033[31m [9] 退出 \033[0m"
				 echo ""
				 read -p ' [&] 选择要执行的功能: ' o2
				 echo "-------------------------------------------\
----------------------------------"
				 if [ ${o2} == 1 ]; then
				 	 sudo ifconfig $interface down
	    		 	 sudo macchanger -r $interface
	    		 	 sudo ifconfig $interface up
					 break 1
			 	 elif [ ${o2} == 2 ]; then
				 	 sudo ifconfig $interface down
	    		 	 sudo macchanger -a $interface
	    		 	 sudo ifconfig $interface up
					 break 1
				 elif [ ${o2} == 3 ]; then
				 	 sudo ifconfig $interface down
	    		 	 sudo macchanger -A $interface
	    		 	 sudo ifconfig $interface up
					 break 1
				 elif [ ${o2} == 9 ]; then
			 	 	 exit 0
				 else
				 	 echo -e "\n [-] 未知选项: $o2"
				 fi
			 done
		elif [ ${o1} == 2 ]; then
			 sudo ifconfig ${interface} down && sudo macchanger -p \
${interface} && sudo ifconfig ${interface} up
			 continue
		elif [ ${o1} == 3 ]; then
			 while :
			 do
			 	echo "-------------------------------------------\
----------------------------------"
			 	read -p ' [&] 选择要切换的信道[1~13,14]: ' o2
			 	if [ $o2 -gt 0 -a $o2 -lt 15 ]; then
			 		 if [ "${mcheck}" == "Monitor"  ]; then
					 	 sudo iwconfig $interface channel $o2 && echo -e " [+] 已切换到$o2信道"
					 	 break 1
					 else
					 	 interface=$(sudo airmon-ng start ${interface} | grep "mac80211 monitor" | cut -d "]" -f3 | cut -d ")" -f1)\
&& sudo iwconfig $interface channel $o2 && \
interface=$( sudo airmon-ng stop ${interface} | grep "mac80211 station" | cut -d "]" -f2 | cut -d ")" -f1) && \
echo -e " [+] 已切换到$o2信道"
						 break 1
					 fi
			 	else
			 	 	echo -e "\n [!] 不存在信道: $o2"
			 	fi
		     done
		elif [ ${o1} == 4 ]; then
			 if [ "${mcheck}" == "Monitor"  ]; then
				  interface=$( sudo airmon-ng stop ${interface} | grep "mac80211 station" | cut -d "]" -f2 | cut -d ")" -f1)\
&& echo " [=] 退出监听模式"
				 continue
			 else
			 	 interface=$(sudo airmon-ng start ${interface} | grep "mac80211 monitor" | cut -d "]" -f3 | cut -d ")" -f1)\
&& echo " [+] 已切换到监听模式"
			 	 continue
			 fi
		elif [ ${o1} == 9 ]; then
			 exit 0
		else
			 echo -e "\n [-] 未知选项: $o1"
		fi
	done	
fi