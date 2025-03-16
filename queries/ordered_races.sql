SELECT  rank() over (order by year, round) as race_order
,       *
FROM    races