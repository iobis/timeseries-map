with obs as (
	select
		dataset_id,
		floor(decimallongitude) + 0.5 as lon,
		floor(decimallatitude) + 0.5 as lat,
		extract(year from to_timestamp(date_mid / 1000)::timestamptz at time zone 'UTC') as year
	from occurrence
	where date_mid is not null and decimallongitude is not null and decimallatitude is not null
)
select
	dataset_id,
	lon,
	lat,
	YEAR,
	count(*) AS records
from obs
group by
	dataset_id,
	lon,
	lat,
	year