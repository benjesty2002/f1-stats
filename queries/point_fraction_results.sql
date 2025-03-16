SELECT  rs.raceid
,       rs.driverid
,       rs.points
,       rs.points * 1.0 / (max(rs.points) over (partition by rs.raceid)) as points_fraction
,       rc.name = 'Indianapolis 500' as is_indy500
,       not (se.category = 'Car Failure' or se.category = 'Unwell') as driver_in_control
FROM    results rs
JOIN    races rc
    ON  rs.raceid = rc.raceid
LEFT JOIN status_extended se
    ON rs.statusid = se.statusid
ORDER BY rs.raceid, rs.points desc, rs.position