import os  
  
input_path = "./SegData/"
output_file = "Test_Data"

file_list = []
file_data = []

for root, dirs, files in os.walk(input_path):
	for fn in files:
		file_list.append(fn)

for file_name in file_list:
	label = file_name.split('.')[0]
	input_path_file = input_path + file_name
	
	data = [label+"\t"+lines for lines in file(input_path_file)]
	file_data.append(data)

fileHandle = open(output_file,'w')
[fileHandle.writelines(lines) for lines in file_data]
fileHandle.close()
