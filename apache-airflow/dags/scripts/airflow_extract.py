import csv
import boto3
import configparser
import psycopg2
from datetime import datetime
import os


the_day = datetime.now().strftime('%Y-%m-%d')
directory = f"extract_{the_day}"
root_folder2 = "/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow"

# if not os.path.isdir(f'{root_folder2}/directory'):
#     os.makedirs(directory)
    
    


# get db dwh connection info
parser = configparser.ConfigParser()
parser.read("/mnt/c/Users/Ron/git-repos/pipeline-scripts/pipeline.conf")
dbname = parser.get("postgres_dwh", "database")
user = parser.get("postgres_dwh", "username")
password = parser.get("postgres_dwh", "password")
host = parser.get("postgres_dwh", "host")
port = parser.get("postgres_dwh", "port")


#[]
#
ps_conn = psycopg2.connect(dbname=dbname, user=user, password=password, host= host, port=port)

cursor = ps_conn.cursor()

drh_inc_check_query = "select COALESCE(MAX(drh.id), -1) from dag_run_history drh"
cursor.execute(drh_inc_check_query)
result = cursor.fetchone()
last_run_id = result[0]
cursor.close()
ps_conn.commit()

#[]
# get airflow db info

parser = configparser.ConfigParser()
parser.read("/mnt/c/Users/Ron/git-repos/pipeline-scripts/pipeline.conf")
dbname2 = parser.get("airflow_db", "database")
user2 = parser.get("airflow_db", "username")
password2 = parser.get("airflow_db", "password")
host2 = parser.get("airflow_db", "host")
port2 = parser.get("airflow_db", "port")

aa_conn = psycopg2.connect(dbname=dbname2, user=user2, password=password2, host= host2, port=port2)

drh_inc_extract_query = "SELECT\
                            id, dag_id, execution_date, state, run_id,\
                            external_trigger, end_date, start_date\
                            FROM dag_run\
                            WHERE id > %s\
                            AND state <> \'running\';"

cursor = aa_conn.cursor()
cursor.execute(drh_inc_extract_query, (last_run_id,))

results = cursor.fetchall()



absolute_path = "/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/"
with open(f'{root_folder2}/{directory}/dag_runs_01.csv', 'w') as fp:
    csv_w = csv.writer(fp, delimiter='|')
    csv_w.writerows(results)



