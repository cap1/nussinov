#!/usr/bin/python

import sys
import os
import fileinput

def read_file(file_path):
	#read sequence form file
	seq =  ''
	for line in fileinput.input(file_path):
		seq += line
	return seq

def fill_field(field, seq, size):
	for i in range(len(field[:][0])):
		for j in range(len(field[i][:])):
			if not j < i:
				#field[i][j] = [0, "o"]
				field[i][j] = gamma(field, i, j, seq, size)

def delta(i,j):
	if ((i == "A" ) and (j == "U")) or ((i == "U") and(j == "A")):
		return 1
	if ((i == "G" ) and (j == "C")) or ((i == "C") and(j == "G")):
		return 1
	return 0

def gamma(field, i, j, seq, size):
	result = [0, "f"]

	print(field[j-1][i+1])
	return result
#	diag = [ field[j-1][i+1][0] + delta(seq[j], seq[i]) , "d" ]
#	left = [ field[j-1][i][0] , "l" ]
#	up   = [ field[j][i+1][0] , "u" ]
#	return diag


file_path = sys.argv[1:]
seq = read_file(file_path)
size = len(seq)
field = [[[ 0 for val in range(2)] for col in range(size)] for row in range(size)]


fill_field(field, seq, size)
for row in field:
	print(row)
