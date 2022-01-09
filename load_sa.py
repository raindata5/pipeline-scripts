import pymssql
import csv
import glob
import os
import datetime, time
from operator import itemgetter 
import re
import psycopg2
from pathlib import Path
# connection = pyodbc.connect("DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=GourmandOLTP;UID=raindata5;PWD=natalia", autocommit=True)
# conn = pymssql.connect(host="localhost", database="GourmandOLTP" )
# conn = pymssql.connect(server='DESKTOP-IJ2FP7P', user='raindata5', password='natalia', database='GourmandOLTP', port=1433)

path = Path(os.getcwd())
base_dir = path.parent.parent

data_in = os.path.join(str(base_dir), "yelp-data/")
conn = psycopg2.connect(dbname='postgres', user='raindata5', password='natalia', host= 'localhost', port=5431)

ok1 = '/mnt/c/Users/Ron/git-repos/yelp-data/test_data/state_abbreviations.csv'


os.path.join(data_in, 'state_abbreviations.csv')
cursor = conn.cursor()
table = 'stateabbreviations'

with open(ok1, encoding='utf-8' ) as read_obj:
    csv_reader = csv.reader(read_obj, delimiter='|', quotechar="'", doublequote=True, escapechar='\\' )
    list_of_tuples = list(map(tuple, csv_reader))
    list_of_tuples = list_of_tuples[1:] # removing header

for row in list_of_tuples:   
    insert_query=f"INSERT INTO {table} VALUES {row}"
    try:
        # cursor.execute("SET QUOTED_IDENTIFIER OFF")
        
        cursor.execute(insert_query)
        
    except Exception as e:
        print(e)
        print(insert_query)
        error = [list(row), insert_query,e,table]

cursor.close()
conn.commit()
conn.close()