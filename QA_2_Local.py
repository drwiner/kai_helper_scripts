"""
David R. Winer 
2019-03-05
david.winer@kasisto.com


change comments of a text file
"""

import argparse

COMMENT_TEXT = "//"


def comment_line(item):
	if item.startswith(COMMENT_TEXT):
		# its already a comment, do nothing
		return
	return "{}{}".format(COMMENT_TEXT, item)

def uncomment_line(item):
	if not item.startswith(COMMENT_TEXT):
		return
	return item[2:]

if __name__ == "__main__":

	parser = argparse.ArgumentParser(description="change qa to local")
	parser.add_argument("--f",dest="FILE_NAME", default="conf/enbd-liv-en-ae.json", help="standard liv")
	parser.add_argument("--r", dest="COMMENT", default="(8,10)", help="which lines to comment out")
	parser.add_argument("--a", dest="UNCOMMENT", default="(3,5)", help="which lines to comment out")
	args = parser.parse_args()
	
	comment = eval(args.COMMENT)
	print("comment {}:".format(comment))
	uncomment = eval(args.UNCOMMENT)
	print("uncomment: {}\n\n".format(uncomment))
	new_file_lines = []

	with open(args.FILE_NAME, 'r') as filename:
		for i, line in enumerate(filename):
			# if i < 12:
			# 	print(i, line)
			# print(i, line)
			if i >= comment[0] and i <= comment[1]:
				commented_line = comment_line(line)
				new_file_lines.append(commented_line)
				print("commented_line: {}, {}\n".format(i, commented_line))
				continue
			if i >= uncomment[0] and i <= uncomment[1]:
				uncommented_line = uncomment_line(line)
				new_file_lines.append(uncommented_line)
				print("uncommented_line: {}, {}\n".format(i, uncommented_line))
				continue
			new_file_lines.append(line)

	print("lines collected")
	
	with open(args.FILE_NAME, "w") as filename:
		for line in new_file_lines:
			filename.write(line)

	print("complete")

