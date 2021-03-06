#!/bin/bash

function check() {
    echo""
    read -p '[&] 选择下载软件的方式 [ APT/yum/apt-get ] ： ' dway
    if [ ${dway} == apt -o ${dway} == APT ]; then
         echo "[=] 将使用APT下载软件."
         aptD="apt"
         aptLinux
    elif [ ${dway} == yum ]; then
         echo "[=] 将使用yum下载软件."
         yumLinux
    elif [ ${dway} == apt-get ]; then
         echo "[=] 将使用apt-get下载软件."
         aptD="apt-get"
         aptLinux
    else
         echo " [-] 未知选项: ${dway}"
	     exit 1
    fi
}

function aptLinux() {
    #apt software
    sudo ${aptD} update
    sudo ${aptD} install neofetch
    sudo ${aptD} install aircrack-ng
    sudo ${aptD} install mdk3
    sudo ${aptD} install macchanger
    sudo ${aptD} install bridge-utils
    sudo ${aptD} install scapy
    sudo ${aptD} install reaver
    sudo ${aptD} install wifite
}

function yumLinux() {
    #yum software
    sudo yum clean all
    sudo yum makecache
    echo " [!] 暂不支持."
    #sudo yum -y install neofetch
    #sudo yum -y install aircrack-ng
    #sudo yum -y install mdk3
    #sudo yum -y install macchanger
    #sudo yum -y install bridge-utils
    #sudo yum -y install scapy
}

function pipLinux() {
    #pip3 install
    pip3 install requests
    pip3 install beautifulsoup4
}

echo ""
echo "-------------------------------------------\
----------------------------------"
read -p '[&] 选择要下载的软件范围 [ ALL,software,pip3 ]: ' downC

if  [ ${downC} == ALL -o ${downC} == all ]; then
      check
      pipLinux
elif [ ${downC} == software ]; then
      check
elif [ ${downC} == pip3 ]; then
      pipLinux
else
      echo " [-] 未知选项: ${downC}"
	 exit 1
fi

