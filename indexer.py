#!/usr/bin/python

import sys, re, psycopg2

input_f = open(sys.argv[1], 'r')

conn = psycopg2.connect("dbname=dictionary user=kimy")
# Autocommit mode
conn.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
cur = conn.cursor()

for line in input_f:
	arr = re.sub("[^\w]", " ",  line).split()
	for word in arr:
		if re.match("^[A-Za-z]*$", word) and len(word) > 3:
			try:
				cur.execute("INSERT INTO word_table (word) VALUES (%s)",(word.lower(),))
			except psycopg2.IntegrityError:
				# The word exists in the table already. Skip
				pass

cur.close()
conn.close()
ins.close()

