#-*-coding:utf-8-*-

import os 
import re
import sys
reload(sys)
sys.setdefaultencoding('utf8') 
#import string

input_path = "./Data/"
output_path = './PureData/'

file_list = []

for root, dirs, files in os.walk(input_path):
	for fn in files:
		file_list.append(fn)

for file_name in file_list:
	file_path_input = input_path + file_name
	data = [lines.split()[1]+"\n" for lines in file(file_path_input) if len(lines)>1]

#	datas = [lines.translate(string.maketrans("",""), string.punctuation) for lines in data]    #去标点

#	datas = [lines.replace("?","").replace(",","") for lines in data]    #去标点

#	replace_reg = re.compile(r"[?,]")
#	datas = [replace_reg.sub("", lines) for lines in data]   #去标点

	datas = [re.sub("[+——！，。？、~@#￥%……&*（）]+".decode("utf8"), "", lines.decode("utf8")) for lines in data]


	file_path_output = output_path + file_name
	fileHandle = open(file_path_output,'w')
	fileHandle.writelines(datas)
	fileHandle.close()

