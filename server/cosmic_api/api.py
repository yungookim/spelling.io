#!/usr/bin/python

from cosmic.api import API
from cosmic.types import Array, String, Integer, Float
import psycopg2

# Name your API
correction_api = API("spelling_correction_api")

conn = psycopg2.connect("dbname=dictionary user=kimy")
conn.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)

#Testing...
@correction_api.action(accepts=String, returns=Array({String, Float}))
def query(query):
  print query
  cur = conn.cursor()
  statement = "SELECT word, similarity(word, %s) AS similarity FROM word_table WHERE word %% %s ORDER BY similarity DESC LIMIT 10"
  #print cur.mogrify(statement, (query, query))
  cur.execute(statement, (query, query))
  ret_val = cur.fetchall()
  cur.close()
  print ret_val
  return ret_val

def release():
  cur = conn.cursor()

if __name__ == "__main__":
  correction_api.run(debug=True)
