create view if not exists vw_full_result_details as
with full_results as (
	select r."year"
	,      r.raceId 
	,      r.round 
	,	   r.name 
	,      r.date 
	,      q."position" qualy_position
	,      sr.grid sprint_grid
	,      iif(sr.grid is null, null, rank() over (partition by r."year", r.round order by iif(sr.grid > 0, sr.grid, 100) asc)) sprint_grid_order
	,      sr.laps sprint_laps
	,	   sr.positionOrder sprint_position
	,      case when sr.resultId is null then null when sstat.status = 'Finished' or SUBSTRING(sstat.status, 1, 1) = '+' then True else False end sprint_finished
	, 	   sstat.status sprint_position_description
	,      r2.grid race_grid
	,      rank() over (partition by r."year", r.round order by iif(r2.grid > 0, r2.grid, 100) asc) race_grid_order
	,      r2.laps race_laps
	,      r2.positionOrder race_position
	,      case when rstat.status = 'Finished' or SUBSTRING(rstat.status, 1, 1) = '+' then True else False end race_finished
	,	   rstat.status race_position_description
	,      r2.fastestLapTime 
	,      iif(min(r2.fastestLapTime) over (partition by r."year", r.round) = r2.fastestLapTime, 1, 0) fastest_lap_point
	,      dotd.driver_id is not null dotd
	,      d.forename 
	,      d.surname 
	from races r 
	cross join drivers d
	left join qualifying q 
		on r.raceId = q.raceId 
		and d.driverId = q.driverId 
	left join fr_scoring qscore 
		on qscore.score_type = 'qualy_pos'
		and qscore."position" = q."position" 
	left join results r2 
		on r2.raceId = r.raceId 
		and r2.driverId = d.driverId
	left join status rstat 
		on r2.statusId = rstat.statusId 
	left join sprint_results sr 
	    on sr.raceId = r.raceId 
	    and sr.driverId = d.driverId 
	left join status sstat 
		on sr.statusId = sstat.statusId 
	left join driver_of_the_day dotd 
		on dotd.race_id = r.raceId 
		and dotd.driver_id = d.driverId 
	where "year" = 2022 and (q.qualifyId is not null or r2.resultId is not null or sr.resultId is not null)
)
, pos_gains as (
	SELECT *
	,      case
			   when sprint_grid_order is null then null
			   when sprint_finished = False then 0
			   when sprint_position > sprint_grid_order then 0
			   else sprint_grid_order - sprint_position
		   end sprint_gains
	,      case
			   when race_grid_order is null then null
			   when race_finished = False then 0
			   when race_position > race_grid_order then 0
			   else race_grid_order - race_position
		   end race_gains
	from full_results
)
SELECT res.*
,      qscore.points qualy_position_points
,      spos_score.points sprint_position_points
,      rpos_score.points race_position_points
,      sg_score.points * res.sprint_gains sprint_gains_points
,      sl_score.points * res.sprint_laps sprint_laps_points
,      rg_score.points * res.race_gains race_gains_points
,      rl_score.points * res.race_laps race_laps_points
,      rfl_score.points * res.fastest_lap_point fastest_lap_points
,      iif(res.dotd, rdotd_score.points, 0) dotd_points
FROM pos_gains res
left join fr_scoring qscore 
	on qscore.score_type = 'qualy_pos'
	and qscore."position" = res.qualy_position
left join fr_scoring spos_score 
	on spos_score.score_type = 'sprint_pos'
	and spos_score."position" = res.sprint_position
left join fr_scoring rpos_score 
	on rpos_score.score_type = 'race_pos'
	and rpos_score."position" = res.race_position
left join fr_scoring sg_score 
	on sg_score.score_type = 'sprint_gains'
left join fr_scoring sl_score 
	on sl_score.score_type = 'sprint_laps'
left join fr_scoring rg_score 
	on rg_score.score_type = 'race_gains'
left join fr_scoring rl_score 
	on rl_score.score_type = 'race_laps'
left join fr_scoring rfl_score 
	on rfl_score.score_type = 'race_fastest_lap'
left join fr_scoring rdotd_score 
	on rdotd_score.score_type = 'race_dotd'
order by res.round, res.race_finished desc, res.race_position
;
