create table fr_scoring (
	score_type STRING
,   "position" INT
,   points INT
)
;

insert into fr_scoring(score_type, "position", points) values
  ("qualy_pos", 1, 50)
, ("qualy_pos", 2, 30)
, ("qualy_pos", 3, 25)
, ("qualy_pos", 4, 20)
, ("qualy_pos", 5, 15)
, ("qualy_pos", 6, 10)
, ("qualy_pos", 7, 8)
, ("qualy_pos", 8, 6)
, ("qualy_pos", 9, 4)
, ("qualy_pos", 10, 2)
, ("sprint_pos", 1, 50)
, ("sprint_pos", 2, 30)
, ("sprint_pos", 3, 25)
, ("sprint_pos", 4, 20)
, ("sprint_pos", 5, 15)
, ("sprint_pos", 6, 10)
, ("sprint_pos", 7, 8)
, ("sprint_pos", 8, 6)
, ("sprint_pos", 9, 4)
, ("sprint_laps", null, 1)
, ("sprint_gains", null, 1)
, ("race_pos", 1, 200)
, ("race_pos", 2, 100)
, ("race_pos", 3, 90)
, ("race_pos", 4, 80)
, ("race_pos", 5, 70)
, ("race_pos", 6, 60)
, ("race_pos", 7, 50)
, ("race_pos", 8, 40)
, ("race_pos", 9, 30)
, ("race_pos", 10, 20)
, ("race_pos", 11, 18)
, ("race_pos", 12, 16)
, ("race_pos", 13, 14)
, ("race_pos", 14, 12)
, ("race_pos", 15, 10)
, ("race_pos", 16, 8)
, ("race_pos", 17, 6)
, ("race_pos", 18, 4)
, ("race_pos", 19, 2)
, ("race_laps", null, 1)
, ("race_fastest_lap", null, 25)
, ("race_gains", null, 5)
, ("race_dotd", null, 25)
;


create table driver_of_the_day (
	race_id INT
,   driver_id INT
)
;

insert into driver_of_the_day(race_id, driver_id) values
  (1074, 844)
, (1075, 844)
, (1076, 844)
, (1077, 830)
, (1078, 830)
, (1079, 1)
, (1080, 815)
, (1081, 1)
, (1082, 844)
, (1083, 815)
, (1084, 854)
, (1085, 832)
, (1086, 830)
, (1087, 830)
, (1088, 830)
, (1089, 856)
, (1091, 815)
, (1092, 20)
, (1093, 20)
, (1094, 817)
, (1095, 1)
, (1096, 20)
;