with base as (
    SELECT  driverid
    ,       count(*) as num_races
    ,       sum(points_fraction) * 1.0 / count(*) as avg_points_fraction
    ,       sum(case when driver_in_control then 1 else 0 end) as included_races
    ,       sum(case when driver_in_control then 0 else 1 end) as excluded_races
    ,       sum(case when driver_in_control then 0 else 1 end) * 1.0 / count(*) as fraction_excluded
    ,       sum(case when driver_in_control then points_fraction else 0 end) * 1.0 
            / sum(case when driver_in_control then 1 else 0 end) as subset_avg_points_fraction
    FROM    point_fraction_results
    WHERE   not is_indy500
    GROUP BY driverid
    ORDER BY sum(points_fraction) * 1.0 / count(*) desc
)
SELECT  d.forename || ' ' || d.surname as name
,       b.*
FROM    base b
JOIN    drivers d
    ON  b.driverid = d.driverid