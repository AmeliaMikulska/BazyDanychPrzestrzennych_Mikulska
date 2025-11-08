CREATE TABLE obiekty (
    id SERIAL PRIMARY KEY,
    nazwa TEXT,
    geom geometry
);

--Zad1--
--a--
INSERT INTO obiekty (nazwa, geom)
VALUES ('obiekt1', st_geomfromtext('compoundcurve( (0 1, 1 1),' ||
                                 'circularstring(1 1, 2 0, 3 1), '||
                                 'circularstring(3 1, 4 2, 5 1), ' ||
                                 '(5 1, 6 1) )', 0)
       );

--b--
INSERT INTO obiekty (nazwa, geom)
VALUES ('obiekt2', st_geomfromtext('curvepolygon(' ||
                                   'compoundcurve( ' ||
                                   '(10 6, 14 6),' ||
                                   'circularstring(14 6, 16 4, 14 2),' ||
                                   'circularstring(14 2, 12 0, 10 2),' ||
                                   '(10 2, 10 6)),'
                                   'circularstring(13 2, 12 1, 11 2, 12 3, 13 2))',
                                   0)
       );

--c--
INSERT INTO obiekty (nazwa, geom)
VALUES ('obiekt3', st_geomfromtext('Polygon((7 15, 10 17, 12 13, 7 15))', 0));

--d--
INSERT INTO obiekty (nazwa, geom)
VALUES ('obiekt4', st_geomfromtext('linestring(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)', 0));

--e--
INSERT INTO obiekty (nazwa, geom)
VALUES ('obiekt5', st_geomfromtext('multipoint z ((38 32 234), (30 30 59))',
                                   0)
       );

--f--
INSERT INTO obiekty (nazwa, geom)
VALUES ('obiekt6', st_geomfromtext('geometrycollection (' ||
                                   'Linestring(1 1, 3 2),' ||
                                   'Point(4 2)' ||
                                   ')',
                                   0)
       );


--Zad2--
Select st_area(st_buffer(st_shortestline(a.geom, b.geom),5)) AS area
FROM obiekty a
JOIN obiekty b ON b.id=4
WHERE a.id=3;

--Zad3--
SELECT
  st_isclosed(geom) AS is_closed, --żeby obiekt można było zamienić na poligon wartość st_IsClosed musi być True
  st_startpoint(geom),
  st_endpoint(geom)
FROM obiekty
WHERE nazwa = 'obiekt4';

UPDATE obiekty
SET geom = st_makepolygon( -- zamieniam linestring na poligon
            st_addpoint( --dodaje do już isniejącego linestringa jednen dodatkowy punkt równy punktowi początkowemu
                geom,
                st_startpoint(geom)
            )
           )
WHERE nazwa = 'obiekt4';

--Zad4--
INSERT INTO obiekty (nazwa, geom)
SELECT 'obiekt7', st_union(a.geom, b.geom)
FROM obiekty a
JOIN obiekty b ON b.id = 4
WHERE a.id = 3;

--Zad5--
SELECT SUM(st_area(st_buffer(geom, 5))) AS total_area
FROM obiekty
WHERE geometrytype(geom) NOT IN (
    'circularstring',
    'compoundcurve',
    'curvepolygon'
    );



