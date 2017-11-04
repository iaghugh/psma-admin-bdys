-- SELECT locality_pid, (ST_DumpPoints(geom)).path
--   FROM admin_bdys_201708.locality_bdys_display_full_res
--   WHERE locality_pid = 'NSW2273';


-- number of points - full res localities --29,444,120
SELECT Count(*) as num_points FROM (
  SELECT (ST_DumpPoints(geom)).geom as geom
  FROM admin_bdys_201708.locality_bdys_display_full_res
) AS sqt;

-- number of points - thinned localities
SELECT Count(*) as num_points FROM (
  SELECT (ST_DumpPoints(geom)).geom as geom
  FROM admin_bdys_201708.locality_bdys_display
) AS sqt;





-- create table of all points in locality bdys -- 29444120 rows -- 3:05
DROP TABLE IF EXISTS admin_bdys_201708.test_locality_points;
WITH pnts AS (
  SELECT locality_pid,
    (ST_DumpPoints(geom)).path as path,
    (ST_DumpPoints(geom)).geom as geom
  FROM admin_bdys_201708.locality_bdys_display_full_res
)
SELECT pnts.locality_pid,
  pnts.path[1]::smallint AS polygon_num,
  pnts.path[2]::smallint AS ring_num,
  pnts.path[3] AS point_num,
  ST_X(pnts.geom)::numeric(9, 6) AS longitude,
  ST_Y(pnts.geom)::numeric(8, 6) AS latitude
  INTO admin_bdys_201708.test_locality_points
FROM pnts;

CREATE INDEX test_locality_points_pid_idx ON admin_bdys_201708.test_locality_points USING btree (locality_pid); -- 4:10
ANALYZE admin_bdys_201708.test_locality_points;