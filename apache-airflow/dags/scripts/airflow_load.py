import csv
import boto3
import configparser
import psycopg2
from datetime import datetime
import os

the_day = datetime.now().strftime('%Y-%m-%d')
directory = f"extract_{the_day}"


# get db dwh connection info
parser = configparser.ConfigParser()
parser.read("/mnt/c/Users/Ron/git-repos/pipeline-scripts/pipeline.conf")
dbname = parser.get("postgres_dwh", "database")
user = parser.get("postgres_dwh", "username")
password = parser.get("postgres_dwh", "password")
host = parser.get("postgres_dwh", "host")
port = parser.get("postgres_dwh", "port")

ps_conn = psycopg2.connect(dbname=dbname, user=user, password=password, host= host, port=port)

cursor = ps_conn.cursor()
absolute_path = "/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow"


# print(os.getcwd())
# ok = os.path.join(absolute_path, directory)

with open(f'{absolute_path}/{directory}/dag_runs_01.csv', encoding='utf-8', newline='') as read_obj:
        csv_reader = csv.reader(read_obj, delimiter='|', quotechar="'", doublequote=True )
        list_of_tuples = list(map(tuple, csv_reader))
        

load_query = 'insert into dag_run_history\
                VALUES\
                %s'

for row in list_of_tuples:
    query = f'insert into dag_run_history VALUES {row}'
    try:
        cursor.execute(query)
    except Exception as e:
        print(e)
cursor.close()

ps_conn.commit()
