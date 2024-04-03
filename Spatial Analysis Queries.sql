--- Query 1
--- Self Join of Attractions table to get unique pairs within a certain distance

-- Finding Total Unique Pairs
select A.attractions_id as Attraction1, A.name as AttractionName1, B.attractions_id as Attraction2, B.name as AttractionName2,
(A.ageom <-> B.ageom) as AttractionsDistance
from ireland_attractions as A, ireland_attractions as B
where (A.attractions_id != B.attractions_id)
and (A.attractions_id < B.attractions_id)
order by AttractionsDistance asc;

select A.attractions_id as Attraction1, A.name as AttractionName1, B.attractions_id as Attraction2, B.name as AttractionName2,
(A.ageom <-> B.ageom) as AttractionsDistance
from ireland_attractions as A, ireland_attractions as B
where (A.attractions_id != B.attractions_id)
and (A.attractions_id < B.attractions_id)
and (A.ageom <-> B.ageom) < 50
order by AttractionsDistance asc;

select A.attractions_id as Attraction1, A.name as AttractionName1, B.attractions_id as Attraction2, B.name as AttractionName2,
(A.ageom <-> B.ageom) as AttractionsDistance
from ireland_attractions as A, ireland_attractions as B
where (A.attractions_id != B.attractions_id)
and (A.attractions_id < B.attractions_id)
and (A.ageom <-> B.ageom) < 100
order by AttractionsDistance asc;

select A.attractions_id as Attraction1, A.name as AttractionName1, B.attractions_id as Attraction2, B.name as AttractionName2,
(A.ageom <-> B.ageom) as AttractionsDistance
from ireland_attractions as A, ireland_attractions as B
where (A.attractions_id != B.attractions_id)
and (A.attractions_id < B.attractions_id)
and (A.ageom <-> B.ageom) < 500
order by AttractionsDistance asc;

-----------------------------------------------------------------------------------------------------------------------------------------------

--- Query 2
--- Self Join of Transportation table to get unique pairs within a certain distance

-- Finding Total Unique Pairs
select A.transportation_id as Stop1, A.stopname as StopName1, B.transportation_id as Stop2, B.stopname as StopName2,
(A.tgeom <-> B.tgeom) as StopDistance
from ireland_transportation as A, ireland_transportation as B
where (A.transportation_id != B.transportation_id)
and (A.transportation_id < B.transportation_id)
order by StopDistance asc;

select A.transportation_id as Stop1, A.stopname as StopName1, 
B.transportation_id as Stop2, B.stopname as StopName2,
(A.tgeom <-> B.tgeom) as StopDistance
from ireland_transportation as A, ireland_transportation as B
where (A.transportation_id != B.transportation_id)
and (A.transportation_id < B.transportation_id)
and (A.tgeom <-> B.tgeom) < 50
order by StopDistance asc;

select A.transportation_id as Stop1, A.stopname as StopName1, B.transportation_id as Stop2, B.stopname as StopName2,
(A.tgeom <-> B.tgeom) as StopDistance
from ireland_transportation as A, ireland_transportation as B
where (A.transportation_id != B.transportation_id)
and (A.transportation_id < B.transportation_id)
and (A.tgeom <-> B.tgeom) < 100
order by StopDistance asc;

select A.transportation_id as Stop1, A.stopname as StopName1, B.transportation_id as Stop2, B.stopname as StopName2,
(A.tgeom <-> B.tgeom) as StopDistance
from ireland_transportation as A, ireland_transportation as B
where (A.transportation_id != B.transportation_id)
and (A.transportation_id < B.transportation_id)
and (A.tgeom <-> B.tgeom) < 500
order by StopDistance asc;

-----------------------------------------------------------------------------------------------------------------------------------------------

--- Query 3
--- Join of Attractions and Transportation table to get unique pairs within a certain distance

-- Finding Total Unique Pairs
select a.attractions_id, a.name as attraction_name, t.transportation_id, t.stopname as transportation_stop, (a.ageom <-> t.tgeom) as Distance
from ireland_attractions as a, ireland_transportation as t order by Distance asc;

select a.attractions_id, a.name as attraction_name, t.transportation_id, t.stopname as transportation_stop, (a.ageom <-> t.tgeom) as Distance
from ireland_attractions as a, ireland_transportation as t where (a.ageom <-> t.tgeom) < 50 order by Distance asc;

select a.attractions_id, a.name as attraction_name, t.transportation_id, t.stopname as transportation_stop, (a.ageom <-> t.tgeom) as Distance
from ireland_attractions as a, ireland_transportation as t where (a.ageom <-> t.tgeom) < 100 order by Distance asc;

select a.attractions_id, a.name as attraction_name, t.transportation_id, t.stopname as transportation_stop, a.county as County, (a.ageom <-> t.tgeom) as Distance
from ireland_attractions as a, ireland_transportation as t where (a.ageom <-> t.tgeom) < 500 order by Distance asc;

-----------------------------------------------------------------------------------------------------------------------------------------------

--- Query 4
--- Calculate Distance from Attractions to Nearest Public Transportation Stop


WITH NearestStop as (
    select a.attractions_id, a.name as attraction_name,
	(select t.tgeom from ireland_transportation as t order by a.ageom <-> t.tgeom LIMIT 1) as nearest_tgeom
    from ireland_attractions as a
)
SELECT ns.attraction_name, (a.ageom <-> ns.nearest_tgeom) as distance_to_nearest_stop
FROM NearestStop as ns, ireland_attractions as a where a.attractions_id = ns.attractions_id order by distance_to_nearest_stop asc;

-----------------------------------------------------------------------------------------------------------------------------------------------

--- Query 5 Point in Polygon Analysis (Count)
--- Find number of Attractions and Stops in each County to do a choropleth analysis


	-- ####### CHOROPLETH ANALYSIS for Attractions #######


	-- 1. Add a new column called NumAttractions in the table ireland_counties
	ALTER TABLE ireland_counties ADD COLUMN NumAttractions INTEGER DEFAULT 0;


	-- 2. Find the number of attractions in each ireland_counties polygon.

	select c.county_id, c.countyname, count(*) AS attraction_count
	from ireland_counties as c, ireland_attractions as a where c.countyname = a.county
	GROUP BY c.county_id;

	-- 3. Updating the NumAttractions column value by using the query above as a subquery

	With AttractionsCountingQuery as (
	select c.county_id, c.countyname, count(*) AS attraction_count
	from ireland_counties as c, ireland_attractions as a where c.countyname = a.county
	GROUP BY c.county_id
	)
	UPDATE ireland_counties
	SET NumAttractions = AttractionsCountingQuery.attraction_count
	FROM AttractionsCountingQuery
	WHERE AttractionsCountingQuery.county_id = ireland_counties.county_id;

	-- 4. Create a Attractions Count View of ireland_counties after update

	DROP VIEW IF EXISTS AttractionsCountView;

	CREATE OR REPLACE VIEW AttractionsCountView AS 
	SELECT county_id, countyname, numattractions, cgeom from ireland_counties
	ORDER BY numattractions DESC;
	
	
	-- ####### CHOROPLETH ANALYSIS for Stops #######


	-- 1. Add a new column called NumStops in the table ireland_counties
	ALTER TABLE ireland_counties ADD COLUMN NumStops INTEGER DEFAULT 0;


	-- 2. Find the number of stops in each ireland_counties polygon.

	select c.county_id, c.countyname, count(*) AS stops_count
	from ireland_counties as c, ireland_transportation as t where st_contains(c.cgeom,t.tgeom)
	GROUP BY c.county_id;


	-- 3. Updating the NumStops column value by using the query above as a subquery

	With StopsCountingQuery as (
		select c.county_id, c.countyname, count(*) AS stops_count
		from ireland_counties as c, ireland_transportation as t where st_contains(c.cgeom,t.tgeom)
		GROUP BY c.county_id
	)
	UPDATE ireland_counties
	SET NumStops = StopsCountingQuery.stops_count
	FROM StopsCountingQuery
	WHERE StopsCountingQuery.county_id = ireland_counties.county_id;

	-- 4. Create a Stops Count View of ireland_counties after update

	DROP VIEW IF EXISTS StopsCountView;

	CREATE OR REPLACE VIEW StopsCountView AS 
	SELECT county_id, countyname, numstops, cgeom from ireland_counties
	ORDER BY numstops DESC;


-----------------------------------------------------------------------------------------------------------------------------------------------


--- Query 6 Point in Polygon Analysis (Area KM2)
--- Find density of Attractions and Stops per KM2 to do a choropleth analysis

	-- ####### CHOROPLETH ANALYSIS for Attractions #######


	-- 1. Add a new column called NumAttractionsDensity in the table ireland_counties
	ALTER TABLE ireland_counties ADD COLUMN NumAttractionsDensity REAL DEFAULT 0.0;


	-- 2. Find the density of attractions per km2 in each ireland_counties polygon.

	select c.county_id, c.countyname, count(*)/(ST_Area(c.cgeom)/1000000) AS AttractionsPerKM2
	from ireland_counties as c, ireland_attractions as a where c.countyname = a.county
	GROUP BY c.county_id;


	-- 3. Updating the NumAttractionsDensity column value by using the query above as a subquery

	With AttractionsDensityQuery as (
		select c.county_id, c.countyname, count(*)/(ST_Area(c.cgeom)/1000000) AS AttractionsPerKM2
		from ireland_counties as c, ireland_attractions as a where c.countyname = a.county
		GROUP BY c.county_id
	)
	UPDATE ireland_counties
	SET NumAttractionsDensity = Round(CAST(AttractionsDensityQuery.AttractionsPerKM2 AS numeric),4)
	FROM AttractionsDensityQuery
	WHERE AttractionsDensityQuery.county_id = ireland_counties.county_id;


	-- 4. Create a Attractions Density View of ireland_counties after update

	DROP VIEW IF EXISTS AttractionsDensityView;

	CREATE OR REPLACE VIEW AttractionsDensityView AS 
	SELECT county_id, countyname, NumAttractionsDensity, cgeom from ireland_counties
	ORDER BY NumAttractionsDensity DESC;
	
	
	-- ####### CHOROPLETH ANALYSIS for Stops #######


	-- 1. Add a new column called NumStopsDensity in the table ireland_counties
	ALTER TABLE ireland_counties ADD COLUMN NumStopsDensity REAL DEFAULT 0.0;
	

	-- 2. Find the density of stops per km2 in each ireland_counties polygon.

	select c.county_id, c.countyname, count(*)/(ST_Area(c.cgeom)/1000000) AS StopsPerKM2
	from ireland_counties as c, ireland_transportation as t where st_contains(c.cgeom,t.tgeom)
	GROUP BY c.county_id;


	-- 3. Updating the NumStopsDensity column value by using the query above as a subquery


	With StopsDensityQuery as (
		select c.county_id, c.countyname, count(*)/(ST_Area(c.cgeom)/1000000) AS StopsPerKM2
		from ireland_counties as c, ireland_transportation as t where st_contains(c.cgeom,t.tgeom)
		GROUP BY c.county_id
	)
	UPDATE ireland_counties
	SET NumStopsDensity = Round(CAST(StopsDensityQuery.StopsPerKM2 AS numeric),4)
	FROM StopsDensityQuery
	WHERE StopsDensityQuery.county_id = ireland_counties.county_id;


	-- 4. Create a Stops Density View of ireland_counties after update

	DROP VIEW IF EXISTS StopsDensityView;

	CREATE OR REPLACE VIEW StopsDensityView AS 
	SELECT county_id, countyname, NumStopsDensity, cgeom from ireland_counties
	ORDER BY NumStopsDensity DESC;


