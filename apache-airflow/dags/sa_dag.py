# run state abbreviations
# check if both tables have the same count
# truncate the second table
# seems I have to use postgres but maybe not conn worked on wsl

from datetime import timedelta
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.postgres_operator import PostgresOperator
from airflow.utils.dates import days_ago
from airflow.operators.dummy_operator import DummyOperator

from airflow.contrib.operators.ssh_operator import SSHOperator
from airflow.contrib.hooks.ssh_hook import SSHHook
import configparser
parser = configparser.ConfigParser()
parser.read("credentials.conf")
webhook_url = parser.get("slack", "webhook_url")

sshhook = SSHHook(ssh_conn_id='ssh_default',key_file= '/home/ronald/.ssh/id_rsa.pub' )
root = '/mnt/c/Users/Ron/git-repos/pipeline-scripts/'

dag = DAG(
    'elt_validation',
    description='load data then run validation check',
    schedule_interval=timedelta(days=1),
    start_date = days_ago(1),
)


# act_ve = BashOperator(
#     task_id='act_vir_env',
#     bash_command='source /mnt/c/Users/Ron/git-repos/yelp-data/yelp-data-venv/bin/activate',
#     dag=dag,
# )

commands = """ source Gourmand-OLTP/oltp-db-venv/bin/activate;
                cd Gourmand-OLTP;
                dbt test --store-failures;
                touch hola_que_tal;

"""


t1 = SSHOperator(
    ssh_hook=sshhook,
    task_id='test_ssh_operator',
    command=commands,
    dag=dag)

t2 = SSHOperator(
    ssh_hook=sshhook,
    task_id='test_ssh_operator2',
    command='echo \"sup\"',
    dag=dag)


# pull_census_data_task = BashOperator(
#     task_id='pull_census_data',
#     bash_command='python gourmand-data-pipelines/census-api.py',
#     dag=dag,
# )

# pull_yelp_business_data_task = BashOperator(
#     task_id='pull_yelp_business_data',
#     bash_command='python gourmand-data-pipelines/yelp-api-scrape-daily.py',
#     dag=dag,
# )

# transform_insert_yelp_data = 

# t3 = SSHOperator(
#     ssh_hook=sshhook,
#     task_id='test_ssh_operator3',
#     command='dbt test',
#     dag=dag)


# t4 = SSHOperator(
#     ssh_hook=sshhook,
#     task_id='test_ssh_operator4',
#     command='touch hola_que_tal',
#     dag=dag)

# load_sa_task = BashOperator(
#     task_id='load_order_data',
#     bash_command='python /mnt/c/Users/Ron/git-repos/pipeline-scripts/load_sa.py',
#     dag=dag,
# )

# check_states_rowcount_task = BashOperator(
#     task_id='check_states_rowcount',
#     bash_command="set -e; python /mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/validator.py \
#     /mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql \
#     /mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql \
#     equals halt",
#     dag=dag,
# )


# check_states_dups_task = BashOperator(
#     task_id='check_states_dups',
#     bash_command="set -e; python /mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/validator_dups.py \
#      /mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql \
#       /mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql",
#     dag=dag,
# )


# final_message_task = BashOperator(
#     task_id='final_message',
#     bash_command=f"curl -X POST -H \'Content-type: application/json\' --data \'{\"text\":\"nice job on the data orchestration ^_^\"}\' \
#     {webhook_url}",
#     dag=dag,
# )



# task1 = DummyOperator(
#             task_id='dummy_task',
#             retries=1,
#             dag=dag
# )

# act_ve >> load_sa_task
t1 >> t2
# t2 >> t3
# t3 >> t4
# load_sa_task >> check_states_rowcount_task
# check_states_rowcount_task >> check_states_dups_task
# check_states_dups_task >> final_message_task
# final_message_task >> task1