Create Database firma
Create Schema ksiegowosc

Create table ksiegowosc.pracownicy (
id_pracownika serial primary key,
imie varchar(50) not null,
nazwisko varchar(50) not null,
adres varchar(150),
telefon varchar(30)
);

Create table ksiegowosc.godziny (
id_godziny serial primary key,
data date not null,
liczba_godzin numeric(5,2) not null check (liczba_godzin >= 0),
id_pracownika int not null references ksiegowosc.pracownicy(id_pracownika) on delete cascade
);

Create table ksiegowosc.pensja (
id_pensji serial primary key,
stanowisko varchar(50) not null,
kwota numeric(10,2) not null check (kwota >=0)
);

Create table ksiegowosc.premia (
id_premii serial not null primary key,
rodzaj varchar(100) not null,
kwota numeric(10,2) not null check (kwota >=0)
);

Create table ksiegowosc.wynagrodzenie (
id_wynagrodzenia serial not null,
data date not null,
id_pracownika int not null references ksiegowosc.pracownicy(id_pracownika) on delete cascade,
id_godziny int not null references ksiegowosc.godziny(id_godziny),
id_pensji int not null references ksiegowosc.pensja(id_pensji),
id_premii int references ksiegowosc.premia(id_premii)
);

ALTER SEQUENCE ksiegowosc.pracownicy_id_pracownika_seq RESTART WITH 1;
ALTER SEQUENCE ksiegowosc.godziny_id_godziny_seq RESTART WITH 1;
ALTER SEQUENCE ksiegowosc.pensja_id_pensji_seq RESTART WITH 1;
ALTER SEQUENCE ksiegowosc.premia_id_premii_seq RESTART WITH 1;
ALTER SEQUENCE ksiegowosc.wynagrodzenie_id_wynagrodzenia_seq RESTART WITH 1;

INSERT INTO ksiegowosc.pracownicy (imie, nazwisko, adres, telefon) VALUES
('Amelia', 'Kowalski', 'ul. Słoneczna 5, Warszawa', '600123456'),
('Anna', 'Nowak', 'ul. Kwiatowa 12, Kraków', '601987654'),
('Piotr', 'Wiśniewski', 'ul. Lipowa 3, Gdańsk', '602334455'),
('Katarzyna', 'Zielińska', 'ul. Brzozowa 8, Poznań', '603556677'),
('Konstancja', 'Kozińska', 'ul. Długa 10, Kraków', '604667788'),
('Maria', 'Kaczmarek', 'ul. Ogrodowa 2, Wrocław', '605778899'),
('Michał', 'Mazur', 'ul. Leśna 7, Katowice', '606889900'),
('Ewa', 'Król', 'ul. Polna 11, Szczecin', '607990011'),
('Paweł', 'Jankowski', 'ul. Spacerowa 15, Lublin', '608100122'),
('Agnieszka', 'Nowicka', 'ul. Kolejowa 9, Rzeszów', '609211233');

INSERT INTO ksiegowosc.pensja (stanowisko, kwota) VALUES
('Programista', 5500.00),
('Księgowa', 1800.00),
('Programista', 3000.00),
('Analityk danych', 4000.00),
('Kierownik projektu', 7000.00),
('Asystent biura', 1000.00),
('Administrator IT', 2800.00),
('Księgowa', 2200.00),
('Programista', 3500.00),
('Magazynier', 1200.00);

INSERT INTO ksiegowosc.premia (rodzaj, kwota) VALUES
('Premia kwartalna', 1000.00),
('Premia za projekt', 1200.00),
('Premia frekwencyjna', 800.00),
('Premia uznaniowa', 1500.00),
('Premia roczna', 2000.00),
('Premia za nadgodziny', 500.00),
('Premia świąteczna', 600.00),
('Premia za efektywność', 700.00),
('Premia motywacyjna', 900.00),
('Premia zespołowa', 1100.00);

INSERT INTO ksiegowosc.godziny (data, liczba_godzin, id_pracownika) VALUES
('2025-10-01', 170.00, 1),
('2025-10-01', 160.00, 2),
('2025-10-01', 155.00, 3),
('2025-10-01', 165.00, 4),
('2025-10-01', 140.00, 5),
('2025-10-01', 180.00, 6),
('2025-10-01', 160.00, 7),
('2025-10-01', 200.00, 8),
('2025-10-01', 150.00, 9),
('2025-10-01', 160.00, 10);

INSERT INTO ksiegowosc.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES
('2025-10-05', 1, 1, 1, 5),
('2025-10-05', 2, 2, 2, NULL),
('2025-10-05', 3, 3, 3, 2),
('2025-10-05', 4, 4, 4, NULL),
('2025-10-05', 5, 5, 5, 1),
('2025-10-05', 6, 6, 6, NULL),
('2025-10-05', 7, 7, 7, 6),
('2025-10-05', 8, 8, 8, NULL),
('2025-10-05', 9, 9, 9, 8),
('2025-10-05', 10, 10, 10, NULL);





