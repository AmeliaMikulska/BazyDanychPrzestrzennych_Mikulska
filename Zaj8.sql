Create database zaj8;

ALTER TABLE "OS_Open_Zoomstack — national_parks" RENAME TO national_parks;
SELECT * FROM national_parks LIMIT 1;

CREATE TABLE public.temp_lake_district AS
SELECT lo_from_bytea(0,
       ST_AsGDALRaster(
           ST_Union(ST_Clip(r.rast, poly.geom, true)),
           'GTiff',
           ARRAY['COMPRESS=DEFLATE']
       )
   ) AS loid
FROM public.uk_250k r,
     public.national_parks poly,
     public.names n
WHERE n.name1 ILIKE '%Lake District%'
  AND ST_Intersects(poly.geom, n.geom)
  AND ST_Intersects(r.rast, poly.geom);

SELECT lo_export(loid, 'C:/pg_export/uk_lake_district.tif')
FROM public.temp_lake_district;

SELECT lo_unlink(loid) FROM public.temp_lake_district;
DROP TABLE public.temp_lake_district;


--Sentiel
CREATE TABLE public.temp_ndwi AS
WITH park AS (
    SELECT poly.geom
    FROM public.national_parks poly, public.names n
    WHERE n.name1 ILIKE '%Lake District%'
      AND ST_Intersects(poly.geom, n.geom)
    LIMIT 1
),
aligned_bands AS (
    SELECT
        ST_Clip(b3.rast, ST_Transform(p.geom, ST_SRID(b3.rast)), true) as rast_green,
        ST_Clip(b8.rast, ST_Transform(p.geom, ST_SRID(b8.rast)), true) as rast_nir
    FROM public.sentinel_b3 b3, public.sentinel_b8 b8, park p
    WHERE ST_Intersects(b3.rast, ST_Transform(p.geom, ST_SRID(b3.rast)))
      AND ST_Intersects(b8.rast, ST_Transform(p.geom, ST_SRID(b8.rast)))
      AND ST_Intersects(b3.rast, b8.rast)
)
SELECT lo_from_bytea(0,
       ST_AsGDALRaster(
           ST_Union(
               ST_MapAlgebra(
                   rast_green, 1,
                   rast_nir, 1,
                   'CASE WHEN ([rast1] + [rast2]) = 0 THEN 0 ELSE ([rast1] - [rast2]) / ([rast1] + [rast2])::float END',
                   '32BF'
               )
           ),
           'GTiff', ARRAY['COMPRESS=DEFLATE']
       )
   ) AS loid
FROM aligned_bands;

SELECT lo_export(loid, 'C:/pg_export/lake_district_ndwi.tif') FROM public.temp_ndwi;





