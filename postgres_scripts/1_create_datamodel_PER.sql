﻿
drop schema if exists "PER_datamodel" cascade;
create schema "PER_datamodel";

-------------------------
-- 0: Load source data --
-------------------------


--------------------------------
-- 1: Create datamodel tables --
--------------------------------

-------------------------------
-- 1.1: Boundary data tables --
-------------------------------

drop table if exists "PER_datamodel"."Geo_level1";
select first_iddp as pcode_level1
	,initcap(lower(nombdep)) as name
	,null as pcode_level0
	,geom
into "PER_datamodel"."Geo_level1"
from per_source.peru_adm1_mapshaper_reproj
;
--select * from "PER_datamodel"."Geo_level1"

drop table if exists "PER_datamodel"."Geo_level2";
select first_idpr as pcode_level2
	,initcap(lower(nombprov)) as name
	,substr(first_idpr,1,2) as pcode_level1
	,geom
into "PER_datamodel"."Geo_level2"
from per_source.peru_adm2_mapshaper_reproj
;
--select * from "PER_datamodel"."Geo_level2"

drop table if exists "PER_datamodel"."Geo_level3";
select iddist as pcode_level3
	,initcap(lower(nombdist)) as name
	,idprov as pcode_level2
	,geom
into "PER_datamodel"."Geo_level3"
from per_source.peru_adm3_mapshaper_reproj
;
--select * from "PER_datamodel"."Geo_level3"




------------------------------------------
-- 1.2: Transform Indicator data tables --
------------------------------------------

------------------
-- Level 3 data --
------------------

drop table if exists "PER_datamodel"."Indicators_3_area";
select iddist as pcode_level3
	,st_area(st_transform(geom,4326)::geography)/1000000 as land_area
into "PER_datamodel"."Indicators_3_area"
from per_source.peru_adm3_mapshaper_reproj
;
--select * from "PER_datamodel"."Indicators_3_area"

drop table if exists "PER_datamodel"."Indicators_3_population";
select case when length(cast(pcode as varchar)) = 5 then '0' || cast(pcode as varchar) else cast(pcode as varchar) end as pcode_level3
	,population
into "PER_datamodel"."Indicators_3_population"
from per_source."Indicators_3_population"
;
--select * from "PER_datamodel"."Indicators_3_population"

drop table if exists "PER_datamodel"."Indicators_3_hazards";
select case when length(cast("PCODE" as varchar)) = 5 then '0' || cast("PCODE" as varchar) else cast("PCODE" as varchar) end as pcode_level3
	,cs_sum + cy_sum as cyclone_phys_exp 	
	,dr_sum as drought_phys_exp
	,eq_sum as earthquake7_phys_exp
	,fl_sum as flood_phys_exp
	,ts_sum as tsunami_phys_exp
into "PER_datamodel"."Indicators_3_hazards"
from per_source."Indicators_3_hazards"
;
--select * from "PER_datamodel"."Indicators_3_hazards"

drop table if exists "PER_datamodel"."Indicators_3_traveltime";
select case when length(cast("PCODE" as varchar)) = 5 then '0' || cast("PCODE" as varchar) else cast("PCODE" as varchar) end as pcode_level3
	,case when tt_mean < 0 then 0 else tt_mean end as traveltime
into "PER_datamodel"."Indicators_3_traveltime"
from per_source."Indicators_3_traveltime"
;
--select * from "PER_datamodel"."Indicators_3_traveltime"



------------------
-- Level 2 data --
------------------


-----------------------------------------------
-- 1.3: Create one Indicator table per level--
-----------------------------------------------

drop table if exists "PER_datamodel"."Indicators_3_TOTAL_temp";
select t0.pcode_level3 as pcode
	,t0.pcode_level2 as pcode_parent
	,land_area
	,population
	,population / land_area as pop_density
	--,case when population = 0 then null else cyclone_phys_exp / population end as cyclone_phys_exp
	,case when population = 0 then null else drought_phys_exp / population end as drought_phys_exp
	,case when population = 0 then null else earthquake7_phys_exp / population end as earthquake7_phys_exp
	,case when population = 0 then null else flood_phys_exp / population end as flood_phys_exp
	,case when population = 0 then null else tsunami_phys_exp / population end as tsunami_phys_exp
	,t4.traveltime
	--,tX.XXX ADD NEW VARIABLE HERE
into "PER_datamodel"."Indicators_3_TOTAL_temp"
from "PER_datamodel"."Geo_level3" t0
left join "PER_datamodel"."Indicators_3_area" 		t1	on t0.pcode_level3 = t1.pcode_level3
left join "PER_datamodel"."Indicators_3_population"	t2	on t0.pcode_level3 = t2.pcode_level3
left join "PER_datamodel"."Indicators_3_hazards" 	t3	on t0.pcode_level3 = t3.pcode_level3
left join "PER_datamodel"."Indicators_3_traveltime" 	t4	on t0.pcode_level3 = t4.pcode_level3
--left join "PER_datamodel"."Indicators_3_XXX" 		tX	on t0.pcode_level3 = tX.pcode_level3
;
--select * from "PER_datamodel"."Indicators_3_TOTAL"

drop table if exists "PER_datamodel"."Indicators_2_TOTAL_temp";
select t0.pcode_level2 as pcode
	,t0.pcode_level1 as pcode_parent
	,level3.population,land_area,pop_density
	,drought_phys_exp,earthquake7_phys_exp,flood_phys_exp,tsunami_phys_exp,traveltime 
	--ADD NEW LEVEL3 VARIABLES HERE
	--ADD NEW LEVEL2 VARIABLES HERE
into "PER_datamodel"."Indicators_2_TOTAL_temp"
from "PER_datamodel"."Geo_level2" t0
left join (
	select pcode_parent
		,sum(population) as population
		,sum(land_area) as land_area
		,sum(pop_density * land_area) / sum(land_area) as pop_density
		--,sum(cyclone_phys_exp * population) / sum(population) as cyclone_phys_exp
		,sum(drought_phys_exp * population) / sum(population) as drought_phys_exp
		,sum(earthquake7_phys_exp * population) / sum(population) as earthquake7_phys_exp
		,sum(flood_phys_exp * population) / sum(population) as flood_phys_exp
		,sum(tsunami_phys_exp * population) / sum(population) as tsunami_phys_exp
		,sum(traveltime * population) / sum(population) as traveltime
		--ADD NEW LEVEL3-VARIABLES HERE AS WELL
	from "PER_datamodel"."Indicators_3_TOTAL_temp"
	group by 1
	) level3
	on t0.pcode_level2 = level3.pcode_parent
--left join "PER_datamodel"."Indicators_2_XXX" 		t1	on t0.pcode_level2 = t1.pcode_level2
;


drop table if exists "PER_datamodel"."Indicators_1_TOTAL_temp";
select t0.pcode_level1 as pcode
	,level2.population,land_area,pop_density
	,drought_phys_exp,earthquake7_phys_exp,flood_phys_exp,tsunami_phys_exp,traveltime 
	--ADD NEW LEVEL2 VARIABLES HERE
	--ADD NEW LEVEL1 VARIABLES HERE
into "PER_datamodel"."Indicators_1_TOTAL_temp"
from "PER_datamodel"."Geo_level1" t0
left join (
	select pcode_parent
		,sum(population) as population
		,sum(land_area) as land_area
		,sum(pop_density * land_area) / sum(land_area) as pop_density
		--,sum(cyclone_phys_exp * population) / sum(population) as cyclone_phys_exp
		,sum(drought_phys_exp * population) / sum(population) as drought_phys_exp
		,sum(earthquake7_phys_exp * population) / sum(population) as earthquake7_phys_exp
		,sum(flood_phys_exp * population) / sum(population) as flood_phys_exp
		,sum(tsunami_phys_exp * population) / sum(population) as tsunami_phys_exp
		,sum(traveltime * population) / sum(population) as traveltime
		--ADD NEW LEVEL3-VARIABLES HERE AS WELL
		--ADD NEW LEVEL2-VARIABLES HERE AS WELL
	from "PER_datamodel"."Indicators_2_TOTAL_temp"
	group by 1
	) level2
	on t0.pcode_level1 = level2.pcode_parent
--left join "PER_datamodel"."Indicators_1_XXX" 		t1	on t0.pcode_level1 = t1.pcode_level1
;



----------------------------------
-- 2.1: Calculate INFORM-scores --
----------------------------------


--calculate INFORM-scores at lowest level:level2
select usp_inform('PER',3);
select usp_inform('PER',2);
select usp_inform('PER',1);

ALTER TABLE "PER_datamodel"."total_scores_level2" DROP COLUMN risk_score, DROP COLUMN vulnerability_score, DROP COLUMN hazard_score, DROP COLUMN coping_capacity_score;
--select * from "PER_datamodel"."total_scores_level1"


--select usp_inform('BEN',1);
--ALTER TABLE "PER_datamodel"."total_scores_level1" DROP COLUMN risk_score, DROP COLUMN vulnerability_score, DROP COLUMN hazard_score, DROP COLUMN coping_capacity_score;
--select * from "PER_datamodel"."total_scores_level1"

--ADD risk scores to Indicators_TOTAL table
drop table if exists "PER_datamodel"."Indicators_3_TOTAL";
select *
into "PER_datamodel"."Indicators_3_TOTAL"
from "PER_datamodel"."Indicators_3_TOTAL_temp" t0
left join "PER_datamodel"."total_scores_level3" t1
on t0.pcode = t1.pcode_level3
;
--select * from "PER_datamodel"."Indicators_2_TOTAL" 

--ADD risk scores to Indicators_TOTAL table
drop table if exists "PER_datamodel"."Indicators_2_TOTAL";
select *
into "PER_datamodel"."Indicators_2_TOTAL"
from "PER_datamodel"."Indicators_2_TOTAL_temp" t0
left join "PER_datamodel"."total_scores_level2" t1
on t0.pcode = t1.pcode_level2
;
--select * from "PER_datamodel"."Indicators_2_TOTAL" 

--ADD risk scores to Indicators_TOTAL table
drop table if exists "PER_datamodel"."Indicators_1_TOTAL";
select *
into "PER_datamodel"."Indicators_1_TOTAL"
from "PER_datamodel"."Indicators_1_TOTAL_temp" t0
left join "PER_datamodel"."total_scores_level1" t1
on t0.pcode = t1.pcode_level1
;
--select * from "PER_datamodel"."Indicators_1_TOTAL" 




