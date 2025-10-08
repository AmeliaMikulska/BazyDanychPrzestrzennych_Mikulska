-- a) Wyświetl tylko id pracownika oraz jego nazwisko.
Select id_pracownika, nazwisko from ksiegowosc.pracownicy

-- b) Wyświetl id pracowników, których płaca jest większa niż 1000.
Select id_pracownika from ksiegowosc.wynagrodzenie 
Join ksiegowosc.pensja on wynagrodzenie.id_pensji=pensja.id_pensji
Where kwota > 1000

-- c) Wyświetl id pracowników nieposiadających premii, których płaca jest większa niż 2000.
Select id_pracownika from ksiegowosc.wynagrodzenie
join ksiegowosc.pensja on wynagrodzenie.id_pensji=pensja.id_pensji
Where id_premii is null and kwota > 2000

-- d) Wyświetl pracowników, których pierwsza litera imienia zaczyna się na literę ‘J’.
Select id_pracownika from ksiegowosc.pracownicy
Where imie like 'J%'

-- e) Wyświetl pracowników, których nazwisko zawiera literę ‘n’ oraz imię kończy się na literę ‘a’.
Select id_pracownika from ksiegowosc.pracownicy
Where nazwisko like '%a' and imie like '%n%'

-- f) Wyświetl imię i nazwisko pracowników oraz liczbę ich nadgodzin, przyjmując, iż standardowy czas pracy to 160
-- h miesięcznie.
Select imie, nazwisko, (godziny.liczba_godzin - 160) as nadgodziny from ksiegowosc.pracownicy
Join ksiegowosc.godziny on pracownicy.id_pracownika=godziny.id_pracownika

-- g) Wyświetl imię i nazwisko pracowników, których pensja zawiera się w przedziale 1500 – 3000 PLN.
Select imie, nazwisko, pensja.kwota from ksiegowosc.pracownicy
Join ksiegowosc.wynagrodzenie on pracownicy.id_pracownika=wynagrodzenie.id_pracownika
Join ksiegowosc.pensja on wynagrodzenie.id_pensji=pensja.id_pensji
Where kwota between 1500 and 3000

-- h) Wyświetl imię i nazwisko pracowników, którzy pracowali w nadgodzinach i nie otrzymali premii.
Select imie, nazwisko, (godziny.liczba_godzin - 160) as nadgodziny from ksiegowosc.pracownicy
Join ksiegowosc.godziny on pracownicy.id_pracownika=godziny.id_pracownika
Join ksiegowosc.wynagrodzenie on pracownicy.id_pracownika=wynagrodzenie.id_pracownika
Where (godziny.liczba_godzin - 160) > 0 and wynagrodzenie.id_premii is NULL

-- i) Uszereguj pracowników według pensji.
Select pracownicy.id_pracownika, imie, nazwisko, pensja.kwota from ksiegowosc.pracownicy
Join ksiegowosc.wynagrodzenie on wynagrodzenie.id_pracownika=pracownicy.id_pracownika
Join ksiegowosc.pensja on wynagrodzenie.id_pensji=pensja.id_pensji
Order by kwota ASC

-- j) Uszereguj pracowników według pensji i premii malejąco.
Select pracownicy.id_pracownika, SUM(pensja.kwota + COALESCE(premia.kwota, 0)) as pensja_i_premia from ksiegowosc.pracownicy
Join ksiegowosc.wynagrodzenie on wynagrodzenie.id_pracownika=pracownicy.id_pracownika
Join ksiegowosc.pensja on wynagrodzenie.id_pensji=pensja.id_pensji
Left Join ksiegowosc.premia on wynagrodzenie.id_premii=premia.id_premii
Group by pracownicy.id_pracownika
Order by pensja_i_premia DESC

-- k) Zlicz i pogrupuj pracowników według pola ‘stanowisko’.
Select stanowisko, Count(id_pensji) as liczba_pracownikow from ksiegowosc.pensja
Group by stanowisko

-- l) Policz średnią, minimalną i maksymalną płacę dla stanowiska ‘kierownik’ (jeżeli takiego nie masz, to przyjmij
-- dowolne inne). Przyjmuję stanowisko: Programista
Select stanowisko, AVG(kwota), MIN(kwota), MAX(kwota) from ksiegowosc.pensja
Where stanowisko like 'Programista'
Group by stanowisko

-- m) Policz sumę wszystkich wynagrodzeń.
Select SUM(kwota) from ksiegowosc.pensja

-- f) Policz sumę wynagrodzeń w ramach danego stanowiska.
Select stanowisko, SUM(kwota) from ksiegowosc.pensja
Group by stanowisko

-- g) Wyznacz liczbę premii przyznanych dla pracowników danego stanowiska.
Select p.stanowisko, Count(pr.kwota) as ilosc_premii from ksiegowosc.pensja p
Join ksiegowosc.wynagrodzenie on p.id_pensji=wynagrodzenie.id_pensji
Left join ksiegowosc.premia pr on pr.id_premii=wynagrodzenie.id_premii
Group by p.stanowisko 
Order by ilosc_premii DESC

-- h) Usuń wszystkich pracowników mających pensję mniejszą niż 1200 zł.
Delete from ksiegowosc.pracownicy p
Using ksiegowosc.wynagrodzenie w 
Join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
Where pe.kwota < 1200;

--Sprawdzenie czy puste
Select p.id_pracownika from ksiegowosc.pracownicy p
Join ksiegowosc.wynagrodzenie w on p.id_pracownika=w.id_pracownika
Join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
Where pe.kwota < 1200;