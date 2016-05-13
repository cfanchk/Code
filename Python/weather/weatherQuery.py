#查询城市温度
import urllib2
import json

infile = file("data.txt")
data = infile.readlines() 
infile.close()

info = {}

for l in data[0:5]:
    city = "".join(l.split()).split(':')
    info[city[0]] = city[1]

name = raw_input("Input a city name:\n")
citycode = info.get(name)

if citycode:
    url = ("http://www.weather.com.cn/data/cityinfo/%s.html" %citycode)
    content = urllib2.urlopen(url).read()
    try:
        dat = json.loads(content)
        result = dat["weatherinfo"]
        str_temp = ("%s\n%s~%s" %(result["weather"],result["temp1"],result["temp2"]))
        print str_temp
    except:
        print "Query failed!"
else:
    print "No data!"
