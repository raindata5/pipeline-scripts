import os
from datetime import timedelta, datetime
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
# from airflow.operators.postgres_operator import PostgresOperator
# from airflow.operators.dummy_operator import DummyOperator
# from airflow.contrib.operators.ssh_operator import SSHOperator
from airflow.contrib.hooks.ssh_hook import SSHHook
from airflow.providers.ssh.operators.ssh import SSHOperator
# a test
sshhook = SSHHook(ssh_conn_id='ssh_default',key_file= '/opt/airflow/dags/id_rsa.pub')
import configparser
parser = configparser.ConfigParser()
# parser.read("/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/credentials.conf")
current_file = os.path.dirname(__file__)
parser.read(os.path.join(current_file, "../credentials.conf"))
webhook_url = parser.get("slack", "webhook_url")
root = '/mnt/c/Users/Ron/git-repos/pipeline-scripts/'
gdp_ve = '/home/ubuntucontributor/gourmand-data-pipelines/dp_venv/bin'
gdp_dir = '/home/ubuntucontributor/gourmand-data-pipelines/python_scripts'
gdp_dir_base = '/home/ubuntucontributor/gourmand-data-pipelines'
dwh_dir = '/home/ubuntucontributor/gourmand-dwh'
dwh_ve = '/home/ubuntucontributor/gourmand-dwh/olap-dp-venv/bin'

dag = DAG(
    'gourmand_data_pipeline',
    description='EtLT pipeline',
    # schedule_interval=timedelta(days=1),
    schedule_interval='30 12 * * *',
    start_date = datetime(2022, 8, 29),
    dagrun_timeout=timedelta(minutes=120)
)

census_api_pull_task = SSHOperator(
    ssh_hook=sshhook,
    task_id='census_api_pull',
    command=f"cd /home/ubuntucontributor/gourmand-data-pipelines/; {gdp_ve}/python {gdp_dir}/census_api.py;",
    dag=dag)

yelp_business_api_pull_task = SSHOperator(
    ssh_hook=sshhook,
    task_id='yelp_business_api_pull',
    command=f"cd /home/ubuntucontributor/gourmand-data-pipelines/; {gdp_ve}/python {gdp_dir}/yelp-api-scrape-daily.py",
    dag=dag)

postgres_business_load_task = SSHOperator(
    ssh_hook=sshhook,
    task_id='postgres_business_load',
    command=f"cd /home/ubuntucontributor/gourmand-data-pipelines/; {gdp_ve}/python {gdp_dir}/postgres-business-load.py;",
    dag=dag)

run_insert_postgres_bh_task = SSHOperator(
    ssh_hook=sshhook,
    task_id='run_insert_postgres_bh',
    command=f"cd /home/ubuntucontributor/gourmand-data-pipelines/; {gdp_ve}/python {gdp_dir}/run-insert-postgres-bh.py;",
    dag=dag)

postgres_to_s3_task = SSHOperator(
    ssh_hook=sshhook,
    task_id='postgres_to_s3',
    command=f"cd {gdp_dir_base}/; {gdp_ve}/python {gdp_dir}/postgres-to-s3.py;",
    retries= 5,
    retry_delay= timedelta(seconds=10),
    dag=dag)

s3_to_bigquery_task = SSHOperator(
    ssh_hook=sshhook,
    task_id='s3_to_bigquery',
    command=f"cd {gdp_dir_base}/; {gdp_ve}/python {gdp_dir}/s3-to-bigquery.py;",
    dag=dag)

postgres_bq_data_validation_task = SSHOperator(
    ssh_hook=sshhook,
    task_id='postgres_bq_data_validation',
    command=f"cd {gdp_dir_base}/; {gdp_ve}/python {gdp_dir}/postgres_bq_data_validation.py halt;",
    dag=dag)

dbt_dwh_bq_task = SSHOperator(
    ssh_hook=sshhook,
    task_id='dbt_dwh_bq',
    command=f"cd {dwh_dir}/; {dwh_ve}/dbt test --select models/staging/*; {dwh_ve}/dbt snapshot; {dwh_ve}/dbt run ; {dwh_ve}/dbt test --store-failures > dbt-test-file.txt",
    dag=dag)

bq_dbt_validation_task = SSHOperator(
    ssh_hook=sshhook,
    task_id='bq_dbt_validation',
    command=f"cd {gdp_dir_base}/; {gdp_ve}/python {gdp_dir}/bq-dbt-validation.py;",
    dag=dag)


#need to reenable by webhook url after removing from github
final_message_task = BashOperator(
    task_id='final_message',
    bash_command="curl -X POST -H \'Content-type: application/json\' --data \'{\"text\":\"nice job on the data orchestration for pipeline performance ^_^\"}\'" + f" \"{webhook_url}\"",
    dag=dag,
)



census_api_pull_task >> yelp_business_api_pull_task
yelp_business_api_pull_task >> postgres_business_load_task
postgres_business_load_task >> run_insert_postgres_bh_task
run_insert_postgres_bh_task >> postgres_to_s3_task
postgres_to_s3_task >> s3_to_bigquery_task
s3_to_bigquery_task >> postgres_bq_data_validation_task
postgres_bq_data_validation_task >> dbt_dwh_bq_task
dbt_dwh_bq_task >> bq_dbt_validation_task
bq_dbt_validation_task >> final_message_task