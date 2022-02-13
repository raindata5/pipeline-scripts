from datetime import timedelta, datetime
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.postgres_operator import PostgresOperator
from airflow.utils.dates import days_ago
from airflow.operators.dummy_operator import DummyOperator

import configparser
parser = configparser.ConfigParser()
# parser.read("/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/credentials.conf")
parser.read("dags/credentials.conf")
webhook_url = parser.get("slack", "webhook_url")

dag = DAG(
    'apache_airflow_perf',
    description="This assists in getting a view of the performance of our pipelines",
    schedule_interval = '30 13 * * *',
    template_searchpath="/opt/airflow/dags/scripts",
    start_date= datetime(2022, 1, 8)
)

root_folder = "/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts"
root_folder2 = "/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow"

root_folder = "/opt/airflow/dags/scripts"
root_folder2 = "/opt/airflow/data_folder"

the_day = datetime.now().strftime('%Y-%m-%d')
directory = f"extract_{the_day}"

mkdir_task = BashOperator(
    task_id = "mkdir",
    bash_command=f"mkdir {root_folder2}/{directory}; pwd;",
    dag=dag
)

# need to provide a previous cmd to create folder as permission is denied if done in following python file
extract_airflow_data_task = BashOperator(
    task_id = "extract_airflow_data",
    bash_command=f"python {root_folder}/airflow_extract.py",
    dag=dag
)

load_airflow_data_task = BashOperator(
    task_id = "load_airflow_data",
    bash_command=f"python {root_folder}/airflow_load.py",
    dag=dag
)


daily_dag_history_model_task = PostgresOperator(
    task_id="daily_dag_history_model",
    postgres_conn_id="PostgresLocalDWH",
    sql=f'/daily_dag_history.sql',
)

valid_res_daily_model_task = PostgresOperator(
    task_id="valid_res_daily_model",
    postgres_conn_id="PostgresLocalDWH",
    sql=f"/validator_res_daily.sql",
)

# print("curl -X POST -H \'Content-type: application/json\' --data \'{\"text\":\"nice job on the data orchestration for pipeline performance ^_^\"}\'",f"{webhook_url}")

final_message_task = BashOperator(
    task_id='final_message',
    bash_command="curl -X POST -H \'Content-type: application/json\' --data \'{\"text\":\"nice job on the data orchestration for pipeline performance ^_^\"}\'" + f" \"{webhook_url}\"",
    dag=dag,
)


mkdir_task >> extract_airflow_data_task
extract_airflow_data_task >> load_airflow_data_task
load_airflow_data_task >> daily_dag_history_model_task
daily_dag_history_model_task >> valid_res_daily_model_task
valid_res_daily_model_task >> final_message_task