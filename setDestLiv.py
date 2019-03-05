"""
David R. Winer 
2019-03-05
david.winer@kasisto.com


Change properties file automatically
"""

import argparse

DEST_HEADER = "app.balserver.adapter.name"

def set_property_value(line, value):
	if line.endswith(value) or line.strip().endswith(value):
		return line
	former_value = line.split("=")[1].strip()
	print("{} --> {}".format(former_value, value))
	return line.replace(former_value, value, 1)

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="change Dest property to DestLiv")
	parser.add_argument("--f",dest="FILE_NAME", default="conf/env.properties", help="env properties file, e.g.")
	parser.add_argument("--p", dest="PROPERTY", default=DEST_HEADER, help="what property we changing")
	parser.add_argument("--v", dest="VALUE", default="DestLiv", help="set property to this value")
	args = parser.parse_args()

	new_file_lines = []
	with open(args.FILE_NAME, 'r') as filename:
		for line in filename:
			if line.startswith(args.PROPERTY):
				new_line = set_property_value(line, args.VALUE)
				new_file_lines.append(new_line)
				continue
			new_file_lines.append(line)

	print('collected')

	with open(args.FILE_NAME, 'w') as filename:
		for line in new_file_lines:
			filename.write(line)

	print('success')