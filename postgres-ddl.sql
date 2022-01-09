drop table business;
drop table business2;

CREATE TABLE if not exists dag_history_daily(
execution_date DATE,
  dag_id VARCHAR(250),
  dag_state VARCHAR(250),
  runtime_seconds numeric(12,4),
  dag_run_count int
);
truncate table dag_history_daily:

select 
	dag_run_history.end_date - dag_run_history.start_date
from dag_run_history


select 
	*
from dag_run_history



INSERT INTO dag_history_daily
  (execution_date, dag_id, dag_state, runtime_seconds, dag_run_count)
SELECT
  CAST(execution_date as DATE),
  dag_id,
  state,
  SUM(EXTRACT(EPOCH FROM (end_date - start_date))),
  COUNT(*) AS dag_run_count
FROM dag_run_history
GROUP BY
  CAST(execution_date as DATE),
  dag_id,
  state;
  
  
select * from dag_history_daily;


drop table validator_summary_daily
CREATE TABLE IF NOT EXISTS validator_summary_daily (
  test_date DATE,
  script_1 varchar(255),
  script_2 varchar(255),
  comp_operator varchar(10),
  test_composite_name varchar(800),
  test_result varchar(20),
  test_count int
);

TRUNCATE TABLE validator_summary_daily;

INSERT INTO validator_summary_daily
  (test_date, script_1, script_2, comp_operator, test_composite_name, test_result, test_count)
SELECT
  CAST(test_run_at AS DATE) AS test_date,
  script_1,
  script_2,
  comp_operator,
  (script_1 || ' ' || COALESCE(script_2,'_') || ' ' || COALESCE(comp_operator,'_')) AS test_composite_name,
  test_result,
  COUNT(*) AS test_count
FROM validation_run_history
GROUP BY
  CAST(test_run_at AS DATE),
  script_1,
  script_2,
  comp_operator,
  (script_1 || ' ' || script_2 || ' ' || comp_operator),
  test_result;

select * from validator_summary_daily;


select * from dag_history_daily