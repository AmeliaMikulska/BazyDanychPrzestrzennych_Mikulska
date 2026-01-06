CREATE DATABASE cw9_1;
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_raster;

DROP TABLE IF EXISTS "raster_scalone";

CREATE TABLE "raster_scalone" AS
SELECT
    1 as id,
    ST_Union(
        ST_SnapToGrid("rast", 0, 0),
        'MAX'
    ) AS rast
FROM "Exports";

SELECT AddRasterConstraints('raster_scalone'::name, 'rast'::name);
CREATE INDEX raster_scalone_idx ON "raster_scalone" USING gist (ST_ConvexHull(rast));
