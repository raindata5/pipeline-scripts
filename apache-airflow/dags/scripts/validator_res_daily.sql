-- this gives us statistics on the results of our validation tests

CREATE TABLE IF NOT EXISTS validator_summary_daily (
  test_date DATE,
  tbl varchar(255),
  pg_tbl_cnt varchar(255),
  bq_tbl_cnt varchar(10),
  test_composite_name varchar(800),
  result varchar(20),
  test_count int
);

TRUNCATE TABLE validator_summary_daily;

INSERT INTO validator_summary_daily
  (test_date, tbl, pg_tbl_cnt, bq_tbl_cnt, test_composite_name, result, test_count)
SELECT
  CAST(test_run_at AS DATE) AS test_date,
  tbl,
  pg_tbl_cnt,
  bq_tbl_cnt,
  (tbl || ' ' || COALESCE(cast(pg_tbl_cnt as text),'_') || ' ' || COALESCE(cast(bq_tbl_cnt as text),'_')) AS test_composite_name,
  result,
  COUNT(*) AS test_count
FROM validation_run_history
GROUP BY
  CAST(test_run_at AS DATE),
  tbl,
  pg_tbl_cnt,
  bq_tbl_cnt,
  (tbl || ' ' || cast(pg_tbl_cnt as text) || ' ' || cast(bq_tbl_cnt as text)),
  result;