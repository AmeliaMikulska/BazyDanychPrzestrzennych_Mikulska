CREATE DATABASE postgis_test;
CREATE EXTENSION postgis;

CREATE TABLE buildings(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    geometry geometry
);

CREATE TABLE roads(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    geometry geometry
);

CREATE TABLE poi(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    geometry geometry
);

INSERT INTO buildings (name, geometry)
VALUES ('BuildingA', st_geomfromtext('Polygon((8 1.5, 10.5 1.5, 10.5 4, 8 4, 8 1.5))')),
       ('BuildingB', st_geomfromtext('Polygon((4 5, 6 5, 6 7, 4 7, 4 5))') ),
       ('BuildingC', st_geomfromtext('Polygon((3 6, 5 6, 5 8, 3 8, 3 6))')),
       ('BuildingD', st_geomfromtext('Polygon((9 8, 10 8, 10 9, 9 9, 9 8))')),
       ('BuildingF', st_geomfromtext('Polygon((1 1, 2 1, 2 2, 1 2, 1 1))'));

INSERT INTO roads(name, geometry)
VALUES ('RoadX', st_MakeLine(st_makepoint(7.5, 0),st_makepoint(7.5, 10.5))),
       ('RoadY', st_geomfromtext('Linestring(0 4.5, 12 4.5)'));

INSERT INTO poi(name, geometry)
VALUES ('G', st_MakePoint(1, 3.5)),
       ('H', st_MakePoint(5.5, 1.5)),
       ('I', st_MakePoint(9.5, 6)),
       ('J', st_geomfromtext('POINT(6.5 6)')),
       ('K', st_geomfromtext('POINT(6 9.5)'));


--a. Wyznacz całkowitą długość dróg w analizowanym mieście.
    SELECT SUM(st_length(roads.geometry)) AS calk_dlugosc_drog from roads;

--b. Wypisz geometrię (WKT), pole powierzchni oraz obwód poligonu reprezentującego budynek o nazwie BuildingA.
    SELECT st_astext(buildings.geometry) as wtk,
           st_area(buildings.geometry) as pole,
           st_perimeter(buildings.geometry) as obwod from buildings
    WHERE name = 'BuildingA';

--c. Wypisz nazwy i pola powierzchni wszystkich poligonów w warstwie budynki. Wyniki posortuj alfabetycznie.
SELECT name, st_area(buildings.geometry) as pole from buildings
ORDER BY name;

--d. Wypisz nazwy i obwody 2 budynków o największej powierzchni.
SELECT name, st_perimeter(buildings.geometry) as obwod from buildings
ORDER BY st_area(geometry) DESC LIMIT 2;

--e. Wyznacz najkrótszą odległość między budynkiem BuildingC a punktem K.
SELECT st_distance(b.geometry, p.geometry) as odleglosc from buildings b
JOIN poi p on p.name = 'K'
WHERE b.name = 'BuildingC';

--f. Wypisz pole powierzchni tej części budynku BuildingC, która znajduje się w odległości większej niż 0.5 od budynku BuildingB.
SELECT st_area(st_difference(bC.geometry, st_buffer(bB.geometry, 0.5))) as pole from buildings bC
JOIN buildings bB on
    bC.name = 'BuildingC'
    and bB.name = 'BuildingB';

--g. Wybierz te budynki, których centroid (ST_Centroid) znajduje się powyżej drogi o nazwie RoadX.
WITH road as (SELECT geometry, st_Y(st_centroid(geometry)) as road_y  from roads
              WHERE name = 'RoadX')
SELECT b.name from buildings b, road r
WHERE st_y(st_centroid(b.geometry)) > r.road_y;

--h. Oblicz pole powierzchni tych części budynku BuildingC i poligonu o współrzędnych (4 7, 6 7, 6 8, 4 8, 4 7), które nie są wspólne dla tych dwóch obiektów.
WITH poligon as (
    SELECT st_geomfromtext('Polygon((4 7, 6 7, 6 8, 4 8, 4 7))') as geometry
)
SELECT st_area(st_symdifference(buildings.geometry, poligon.geometry)) as pole from buildings, poligon
WHERE buildings.name = 'BuildingC';
