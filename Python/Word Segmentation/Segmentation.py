import os  
  
project_path = "~/Documents/ltp-master/bin/examples/"
model_exe = "cws_cmdline"
model_path = "~/Documents/ltp-master/bin/" + "cws.model"
input_path = "./PureData/"
output_path = './SegData/'

file_list = []

for root, dirs, files in os.walk(input_path):
	for fn in files:
		file_list.append(fn)

for file_name in file_list:
	input_path_file = input_path + file_name
	output_path_file = output_path + file_name
	
	command = project_path + model_exe + " --segmentor-model " + model_path + " --input " + input_path_file + " >> " + output_path_file 
	os.system(command)
