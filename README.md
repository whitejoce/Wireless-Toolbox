# Toolbox
One code.
*   Toolbox  
    

 使用`Python`编写,`Shell`脚本调用系统指令(工具脚本)；

 Python版本: 3；

 系统环境(已测试): Kali,Ubuntu,Raspbian.

* * *

  

*   一键下载所需工具 :
    

 `$ python toolbox.py --install `

*   功能:  
    

 一键apt更新(`-U` or `--update`): 相当于apt \[update,upgrade,autoremove\]；

 制造SSID为新闻标题的AP(`--fakeAP`):  新闻摘自[Sina](https://news.sina.com.cn/china/)；

 快速使用Namp扫描系统漏洞(`--Nvuln`):不用记指令了；

 了解系统详情(`-V `or `--sysver`):使用neofetch工具；

*   使用制造AP功能需要网卡支持监听模式,还请注意是否更改mac地址问题(可以选择)；
    

 更多功能还请看源代码(`toolbox.py`),欢迎交流。

  

*   功能(badAP,WEP,WAP2)还未实现,后续更新:

 badAP : 无赖AP，将整合进fakeAP;

 WEP: 破解wep(穷尽数据包)；

 WPA2: 基于四次握手尝试破解wpa；

 Wireless: 基于Hack-RF的蓝牙和无线方面的快速调试：

  

* * *

*   使用方法:
    
 `$ pyhton toolbox.py -h`

*   选项(只能带一个选项):
    

 `$ python toolbox.py -{h,V,i,U,d}`

 `$ python toolbox.py --{sysver,update,fakeAP,install,download,Nvuln,
 info,WEP,WPA2}`

