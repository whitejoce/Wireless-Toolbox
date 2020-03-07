#!/usr/bin/python
# _*_coding: utf-8 _*_

import os
import sys
import requests
from bs4 import BeautifulSoup

reload(sys)  #ignore the error
sys.setdefaultencoding('utf8') #ignore the error

res = requests.get("http://news.sina.com.cn/china/")
res.encoding = 'utf-8'
#soup = BeautifulSoup(res.text, 'lxml')
#print(soup.title.text)
soup=BeautifulSoup(res.text,'html.parser')
#print(soup.text)
if os.path.exists("code/news.txt"):
    os.remove("code/news.txt")
getnews =""
for news in soup.select(".right-content"):
    #print(news)
    #print (news.select("a"))
    new_as=news.select("a")
    for news_a in new_as:
        getnews = getnews + (news_a.text) +('\n')
print("\n[+]Get news:")
print(getnews)


with open('code/news.txt','w') as f:
       f.write(getnews)

os.system("sudo bash code/newsap.sh")