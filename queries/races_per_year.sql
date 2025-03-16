WITH races_with_result AS (
    SELECT DISTINCT raceid
    FROM    results
    WHERE   positionorder = 1
)
SELECT  r.year
,       count(*) AS races_in_year
FROM    races r
JOIN    races_with_result rwr
    ON  r.raceid = rwr.raceid
GROUP BY r.year
