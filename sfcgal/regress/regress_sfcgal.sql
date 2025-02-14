---
--- Regression tests for PostGIS SFCGAL backend
---

-- We only care about testing PostGIS prototype here
-- Behaviour is already handled by SFCGAL own tests

SELECT 'postgis_sfcgal_version', count(*) FROM (SELECT postgis_sfcgal_version()) AS f;
SELECT 'ST_Tesselate', ST_AsText(ST_Tesselate('GEOMETRYCOLLECTION(POINT(4 4),POLYGON((0 0,1 0,1 1,0 1,0 0)))'));
SELECT 'ST_3DArea', ST_3DArea('POLYGON((0 0 0,1 0 0,1 1 0,0 1 0,0 0 0))');
SELECT 'ST_Extrude_point', ST_AsText(ST_Extrude('POINT(0 0)', 1, 0, 0));
SELECT 'ST_Extrude_line', ST_AsText(ST_Extrude(ST_Extrude('POINT(0 0)', 1, 0, 0), 0, 1, 0));
-- In the first SFCGAL versions, the extruded face was wrongly oriented
-- we change the extrusion result to match the original
SELECT 'ST_Extrude_surface',
CASE WHEN postgis_sfcgal_version() = '1.0'
THEN
    ST_AsText(ST_Extrude(ST_Extrude(ST_Extrude('POINT(0 0)', 1, 0, 0), 0, 1, 0), 0, 0, 1))
ELSE
    regexp_replace(
    regexp_replace(
    ST_AsText(ST_Extrude(ST_Extrude(ST_Extrude('POINT(0 0)', 1, 0, 0), 0, 1, 0), 0, 0, 1)) ,
    '\(\(0 1 0,1 1 0,1 0 0,0 1 0\)\)', '((1 1 0,1 0 0,0 1 0,1 1 0))'),
    '\(\(0 1 0,1 0 0,0 0 0,0 1 0\)\)', '((1 0 0,0 0 0,0 1 0,1 0 0))')
END;

SELECT 'ST_ForceLHR', ST_AsText(ST_ForceLHR('POLYGON((0 0,0 1,1 1,1 0,0 0))'));
SELECT 'ST_Orientation_1', ST_Orientation(ST_ForceLHR('POLYGON((0 0,0 1,1 1,1 0,0 0))'));
SELECT 'ST_Orientation_2', ST_Orientation(ST_ForceRHR('POLYGON((0 0,0 1,1 1,1 0,0 0))'));
SELECT 'ST_MinkowskiSum', ST_AsText(ST_MinkowskiSum('LINESTRING(0 0,4 0)','POLYGON((0 0,1 0,1 1,0 1,0 0))'));
SELECT 'ST_StraightSkeleton', ST_AsText(ST_StraightSkeleton('POLYGON((1 1,2 1,2 2,1 2,1 1))'));
SELECT 'ST_ConstrainedDelaunayTriangles', ST_AsText(ST_ConstrainedDelaunayTriangles('GEOMETRYCOLLECTION(POINT(0 0), POLYGON((2 2, 2 -2, 4 0, 2 2)))'));
SELECT 'postgis_sfcgal_noop', ST_NPoints(postgis_sfcgal_noop(ST_Buffer('POINT(0 0)', 5)));
SELECT 'ST_3DConvexHull', ST_AsText(ST_3DConvexHull('MULTIPOINTZ(0 0 5, 1 5 3, 5 7 6, 9 5 3 , 5 7 5, 6 3 5)'));
