-- SELECT  raceid, driverid, q3, position, substr(q3, length(q3)-3, 3) as thousandths
-- FROM qualifying
-- WHERE substr(q3, length(q3)-2, 3) = '000'

-- with qualy_times as (
--     select case when length(q3) > 2 then q3 when length(q2) > 2 then q2 else q1 end as qualy_time,
--             raceid,
--             position,
--             driverid
--     from qualifying
-- )
-- SELECT length(q.qualy_time) - instr(q.qualy_time, '.') as decimal_places, r.year, count(*)
-- FROM qualy_times q
-- join races r on q.raceid = r.raceid
-- where length(q.qualy_time) > 2
-- group by length(q.qualy_time) - instr(q.qualy_time, '.'), r.year
-- order by r.year, count(*)

-- with qualy_times as (
--     select case when length(q3) > 2 then q3 when length(q2) > 2 then q2 else q1 end as qualy_time,
--             raceid,
--             position,
--             driverid
--     from qualifying
-- )
-- SELECT substr(qualy_time, length(qualy_time)-2, 3) as thousandths, count(*)
-- FROM qualy_times
-- where position = 1
-- GROUP BY substr(qualy_time, length(qualy_time)-2, 3)
-- order by substr(qualy_time, length(qualy_time)-2, 3)

with qualy_times as (
    select case when length(q3) > 2 then q3 when length(q2) > 2 then q2 else q1 end as qualy_time,
            raceid,
            position,
            driverid
    from qualifying
)
SELECT *
from qualy_times
where position = 1 and substr(qualy_time, length(qualy_time)-2, 3) = '000'