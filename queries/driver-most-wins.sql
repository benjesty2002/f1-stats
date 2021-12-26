SELECT d.driverId, d.forename, d.surname, count(*) as num_wins
FROM results r 
LEFT JOIN drivers d ON r.driverId = d.driverId
WHERE r.position = '1'
GROUP BY d.driverId, d.forename, d.surname
ORDER BY num_wins DESC