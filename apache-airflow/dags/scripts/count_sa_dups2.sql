with cnt_dr as (
	select ROW_NUMBER() OVER(partition by us_state order by us_state) cnt from stateabbreviations2
)
select count(cnt)
from cnt_dr
where cnt > 1



