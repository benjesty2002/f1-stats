SELECT  nationality
,       count(*) as num_drivers
,       sum(avg_points_fraction) * 1.0 / count(*) as avg_points_fraction
,       sum(subset_avg_points_fraction) * 1.0 / count(*) as subset_avg_points_fraction
,       sum(case when num_races >= 10 then 1 else 0 end) as num_drivers_10_races_plus
,       sum(case when num_races >= 10 then avg_points_fraction else 0 end) * 1.0 
        / sum(case when num_races >= 10 then 1 else 0 end) as avg_points_fraction_10_plus
,       sum(case when num_races >= 10 then subset_avg_points_fraction else 0 end) * 1.0 
        / sum(case when num_races >= 10 then 1 else 0 end) as subset_avg_points_fraction_10_plus
FROM    driver_average_point_fraction dapf
JOIN    drivers d
    ON  d.driverid = dapf.driverid
GROUP BY d.nationality
ORDER BY sum(avg_points_fraction) * 1.0 / count(*) desc