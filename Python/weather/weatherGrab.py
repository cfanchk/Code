#抓取城市代号
import urllib2
url1 = "http://m.weather.com.cn/data5/city.xml"
content = urllib2.urlopen(url1).read()
provinces = content.split(',')

url = "http://m.weather.com.cn/data5/city%s.xml"
out = file("data.txt","w")
cityinfo = {}

for p in provinces:
    p_code = p.split('|')[0]
    url2 = url % p_code
    content = urllib2.urlopen(url2).read()
    cities = content.split(',')

    for c in cities:
        c_code = c.split('|')[0]
        url3 = url % c_code
        content = urllib2.urlopen(url3).read()
        areas = content.split(',')

        for a in areas:
            info = a.split('|')
            code = info[0]
            name = info[1]
            out.write(name + ":")
            out.write("101" + code)
            out.write('\n')
            print name + ":" + code

out.close()




