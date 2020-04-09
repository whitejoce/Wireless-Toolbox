#!/bin/bash

function check() {
    
    read -p '[&] Your System Use [ APT/yum/apt-get ] to download software: ' dway
    if [ ${dway} == apt -o ${dway} == APT ]; then
          echo "[=] Use APT to download software."
          aptD="apt"
          aptLinux
    elif [ ${dway} == yum ]; then
          echo "[=] Use yum to download software."
          yumLinux
     elif [ ${dway} == apt-get ]; then
          echo "[=] 将使用apt-get下载软件."
          aptD="apt-get"
          aptLinux
    else
          echo " [-] Unknown option: ${dway}"
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
}

function yumLinux() {
    #yum software
    sudo yum clean all
    sudo yum makecache
    echo " [!] Not support."
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

read -p '[&] Choose to download[ ALL,software,pip3 ]: ' downC

if  [ ${downC} == ALL -o ${downC} == all ]; then
      check
      pipLinux
elif [ ${downC} == software ]; then
      check
elif [ ${downC} == pip3 ]; then
      pipLinux
else
      echo " [-] Unknown option: ${downC}"
	 exit 1
fi
