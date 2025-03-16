SELECT  rc.race_order
,       sum(case when dr.nationality = 'Finnish' then 1 else 0 end) as fins
,       group_concat(case when dr.nationality = 'Finnish' then dr.forename || ' ' || dr.surname else '' end, ',')
,       rc.year
,       rc.name
FROM    ordered_races rc
JOIN    results rs
    ON  rc.raceid = rs.raceid
JOIN    ordered_drivers dr
    ON  rs.driverid = dr.driverid
GROUP BY rc.race_order
