import os 
import glob
import importlib.util
from airflow.models import DAG
import pytest
from airflow.utils.dag_cycle_tester import check_cycle

# DAG_PATH = os.path.join(os.getcwd(), "../dags/**/*.py")
# DAG_FILES = glob.glob(DAG_PATH, recursive=True)

def generate_dag_files():
    DAG_PATH = os.path.join("/opt/airflow/dags/**/*.py")
    DAG_FILES = glob.glob(DAG_PATH, recursive=True)
    return DAG_FILES, DAG_PATH

def parse_dag_file(dag_file, dag_path):
    module_name, *_ = os.path.splitext(dag_file)
    module_path = os.path.join(dag_path, dag_file) # dag_file replaces the pattern
    mod_spec = importlib.util.spec_from_file_location(name=module_name, location=module_path) # seems dag_file is sufficient as well
    module_from_spec = importlib.util.module_from_spec(mod_spec)
    mod_spec.loader.exec_module(module_from_spec)

    dag_objs = {var for var in vars(module_from_spec).values() if isinstance(var, DAG)}
    assert dag_objs

    for dag in dag_objs:
        dag: DAG
        print(dag.dag_id)
        check_cycle(dag)

# @pytest.mark.parametrize("dag_file", DAG_FILES)
def test_dag_parsing():
    dag_files, dag_path = generate_dag_files()
    for dag_file in dag_files:
        parse_dag_file(dag_file=dag_file, dag_path=dag_path)

