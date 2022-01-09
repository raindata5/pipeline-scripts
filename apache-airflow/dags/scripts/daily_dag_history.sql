-- used to get stats for each day of each dag during each state
CREATE TABLE if not exists dag_history_daily(
execution_date DATE,
  dag_id VARCHAR(250),
  dag_state VARCHAR(250),
  runtime_seconds numeric(12,4),
  dag_run_count int
);
truncate table dag_history_daily;

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
