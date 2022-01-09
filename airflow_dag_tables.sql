CREATE TABLE dag_run_history(
    id int,
    dag_id VARCHAR(250),
    execution_date timestamptz,
    "state" VARCHAR(250),
	run_id VARCHAR(250),
	external_trigger boolean,
	end_date timestamptz,
	start_date TIMESTAMPtz
); 

CREATE TABLE validation_run_history (
  script_1 varchar(255),
  script_2 varchar(255),
  comp_operator varchar(10),
  test_result varchar(20),
  test_run_at timestamp
);