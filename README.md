# Wireless-Toolbox

* 声明
 
 此脚本仅做学习交流（以及快速配置无线审计工具），切勿用于任何非法用途！
 
 * 关于
 
 现已全部汉化，以后还是以中文来编写，如果对此脚本感兴趣，还请星标，感谢支持！:)
 
 目前仍在龟速优化（模块化编写）
 
* * *

* Toolbox  
    

 使用`Python`编写,`Shell`脚本调用系统指令；

 Python版本: 3.x

 系统环境(已测试): Kali,Ubuntu,Raspbian.
 
 此脚本在于快速使用或实现某一功能，所以部分功能依赖于其他其他软件(需要下载);
 
 改进了功能的调用，使得更加方便

* * *

  

*   一键下载所需工具 :
    

 `$ ./toolbox.py --install `

* 功能:  
    

 一键apt更新(`-U` or `--update`): 相当于apt \[update,upgrade,autoremove,autoclean\]；

 快速使用Namp扫描系统漏洞(`--Nvuln`):不用记指令了；
 
 无线网络嗅探(`--scapy`): 嗅探隐藏SSID，嗅探，FTP账号以及登录口令嗅探；
 
 了解系统详情(`-V `or `--sysver`):使用neofetch工具；
 
 无线网络嗅探(`--scapy`): 嗅探隐藏SSID，嗅探Probe，FTP账号以及登录口令嗅探；
 
 无线网卡快速设置（`--netcard`）
 
 
 * * *
 
 * 针对网络协议(IEEE 802.11)`--IEEE`:
 
   分为四个选项(在引导菜单中可以看到):
 
   创建恶意无线热点：新闻AP(SSID)，随机AP(SSID)，自定义AP(SSID);
 
   无赖AP，针对以太网（evil twin）;
 
   制造SSID为新闻标题的AP: 新闻摘自[Sina](https://news.sina.com.cn/china/)；
 
   WEP破解: Caffe Latte,;
 
   WPS破解:暴力破解PIN码(对网络要求很高，仍在完善对reaver的使用)，选项:`getPIN`
 
 使用制造AP功能需要网卡支持监听模式,还请注意是否更改mac地址问题(可以选择)；
    
 更多功能还请看源代码(`toolbox.py`),欢迎交流。

  
***

*   以下功能还未实现,后续更新:

 WEP: 破解wep(穷尽数据包)；

 WPA2: 根据四次握手尝试破解wpa;

 Wireless: 蓝牙(CC2540 USB),ZigBee(CC2531 USB)和无线(HackRF One)方面的快速调试;
 
 MITM: 中间人攻击
 
 [pwnagotchi](https://github.com/evilsocket/pwnagotchi): 处理“吃”来的握手包
  

* * *

*   使用方法:
    
 `$ ./toolbox.py -h`

*   选项(只能带一个选项):
    

 `# ./toolbox.py -{h,V,i,U,d}`

 `# python toolbox.py --{sysver,update,IEEE,install,download,Nvuln,
 info,Wifi}`
 
 
 * * *
 *    推荐书籍
  
  《Kali Linux无线渗透测试指南》 作者：[英]Cameron Buchanan,[印度]Vivek Ramachandran 
  [此书链接](https://www.epubit.com/bookDetails?id=N13524);
  
  《Python绝技：运用Python成为顶级黑客》 作者：[美]TJ O'Connor [此书链接](http://www.broadview.com.cn/book/4495);
 
 * * *
 
 * 功能报错提示
 
 在`IEEE.sh,scapy.sh`文件中，关于Python的调用可以自行修改变量`pyName`(比如调用python3命令是`python3`，就改成`python3`)，不然可能会报错。
 
 * 帮助
 
 如提示设备未托管，无法上网，请将`/etc/NetworkManager/NetworkManager.conf `
 中的`managed=false`改为`managed=true`,保存后重启(或者`sudo service network-manager restart`)；
 
 
 * * *
 * Welcome translation into English（Sorry for my poor English）.
