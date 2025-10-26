CREATE EXTENSION postgis;



--Zad 1
--Znajdz budynki, które zostały wybudowane lub wyremontowane na przestrzeni roku (zmiana pomiędzy 2018 a 2019)
CREATE TABLE public.zad1 AS
SELECT b19.polygon_id,
       b19.geom,
       'new' AS status
FROM public.t2019_kar_buildings b19
LEFT JOIN public.t2018_kar_buildings b18 ON b19.polygon_id = b18.polygon_id
WHERE b18.polygon_id IS NULL --wybieram te budnyki które nie istnieją w roku 2018
UNION ALL
SELECT b19.polygon_id,
       b19.geom,
       'changed' AS status
FROM public.t2019_kar_buildings b19
JOIN public.t2018_kar_buildings b18 ON b19.polygon_id = b18.polygon_id
WHERE NOT st_equals(b19.geom, b18.geom);
--wybieram te budynki gdzie polygon_id jest to samo w 2018 i 2019 ale geometria jest zmieniona



--Zad 2
--Znajdź ile nowych POI pojawiło się w promieniu 500 m od wyremontowanych lub wybudowanych budynków,
--które znalezione zostały w zadaniu 1. Policz je wg ich kategorii
SELECT poi.type, COUNT(*) AS nowe_poi
FROM (SELECT poi_id, geom, type FROM public.t2019_kar_poi_table
      EXCEPT
      SELECT poi_id, geom, type FROM public.t2018_kar_poi_table) AS poi
JOIN zad1 ON st_dwithin(poi.geom::geography, zad1.geom::geography, 500)
GROUP BY poi.type
ORDER BY nowe_poi DESC;



--Zad3
--Utwórz nową tabelę o nazwie ‘streets_reprojected’, która zawierać będzie dane z tabeli T2019_KAR_STREETS przetransformowane
--do układu współrzędnych DHDN.Berlin/Cassini.
CREATE TABLE public.streets_reprojected AS
SELECT *, st_transform(geom, 3068) AS geom_nowe
FROM public.t2019_kar_streets;

ALTER TABLE streets_reprojected
DROP COLUMN geom;

ALTER TABLE streets_reprojected
RENAME COLUMN geom_nowe TO geom;



--Zad4
--Stwórz tabelę o nazwie ‘input_points’ i dodaj do niej dwa rekordy o geometrii punktowej.
CREATE TABLE public.input_points (
    id SERIAL PRIMARY KEY ,
    geom geometry(Point, 4326)
);

INSERT INTO public.input_points (geom)
VALUES (st_setsrid(st_makepoint(8.36093, 49.03174), 4326)),
       (st_setsrid(st_makepoint(8.39876, 49.00644), 4326));



--Zad5
--Zaktualizuj dane w tabeli ‘input_points’ tak, aby punkty te były w układzie współrzędnych DHDN.Berlin/Cassini.
ALTER TABLE public.input_points
ALTER COLUMN geom TYPE geometry(Point, 3068)
USING st_transform(geom, 3068);



--Zad6
--Znajdź wszystkie skrzyżowania, które znajdują się w odległości 200 m od linii zbudowanej
--z punktów w tabeli ‘input_points’. Wykorzystaj tabelę T2019_STREET_NODE. Dokonaj
--reprojekcji geometrii, aby była zgodna z resztą tabel.
ALTER TABLE public.t2019_kar_street_node
ALTER COLUMN geom TYPE geometry(Point, 3068)
USING st_transform(geom, 3068);

WITH linia AS (SELECT st_makeline(input_points.geom ORDER BY id) AS geom FROM public.input_points)
SELECT n.gid, st_astext(n.geom) FROM public.t2019_kar_street_node n
JOIN linia ON st_dwithin(n.geom, linia.geom, 200);



--Zad7
--Policz jak wiele sklepów sportowych (‘Sporting Goods Store’ - tabela POIs) znajduje się
--w odległości 300 m od parków (LAND_USE_A)
SELECT COUNT(poi.gid) FROM public.t2019_kar_poi_table poi
JOIN public.t2019_kar_land_use_a land ON st_dwithin(poi.geom::geography, land.geom::geography, 300)
WHERE poi.type LIKE 'Sporting Goods Store' AND land.type LIKE '%Park%';



--Zad8
--Znajdź punkty przecięcia torów kolejowych (RAILWAYS) z ciekami (WATER_LINES). Zapisz
--znalezioną geometrię do osobnej tabeli o nazwie ‘T2019_KAR_BRIDGES’
CREATE TABLE t2019_kar_bridges AS
SELECT r.gid AS railways_id,
       w.gid AS water_lines_id,
       st_intersection(r.geom, w.geom) AS geom --zwraca geometrię np. konkretny punkt przecięcia
FROM public.t2019_kar_railways r
JOIN public.t2019_kar_water_lines w ON st_intersects(r.geom, w.geom) --zwraca True/False, gdy geometrie przecinają się
WHERE r.link_id < w.link_id; --brak powtórzeń? (problem: różny wynik przy zmianie znaku '<' 26 vs 34, który jest poprawny?)








