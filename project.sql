DROP TABLE Uzivatel CASCADE CONSTRAINTS;
DROP TABLE Rezervacia CASCADE CONSTRAINTS;
DROP TABLE Vybavenie CASCADE CONSTRAINTS;
DROP TABLE Miestnost CASCADE CONSTRAINTS;
DROP TABLE Typ_rezervacie CASCADE CONSTRAINTS;
DROP INDEX explain_index;
DROP MATERIALIZED VIEW materialized_view;

CREATE TABLE Uzivatel(
    id_uzivatela VARCHAR(8) PRIMARY KEY NOT NULL,
    meno VARCHAR(20) NOT NULL,
    priezvisko VARCHAR(20) NOT NULL,
    email VARCHAR(20) NOT NULL,
    heslo VARCHAR(20) NOT NULL,
    rola CHAR(20) NOT NULL,
    CHECK (LENGTH(heslo) > 8)
);

CREATE TABLE Rezervacia(
    id_rezervacie INT PRIMARY KEY NOT NULL,
    typ CHAR(20),
    od VARCHAR(5),
    do VARCHAR(5),
    datum DATE,
    den CHAR(10),
    id_uzivatela VARCHAR(8) NOT NULL,
    id_miestnosti VARCHAR(4) NOT NULL
);

CREATE TABLE Typ_rezervacie(
    id_rezervacie INT NOT NULL,
    typ VARCHAR(20),
    predmet CHAR(5),
    obor CHAR(20),
    rocnik INT,
    termin VARCHAR(20),
    zameranie CHAR(20),
    nazov CHAR(20)
);

CREATE TABLE Miestnost(
    id_miestnosti  VARCHAR(4) PRIMARY KEY NOT NULL,
    miesto VARCHAR(20),
    kapacita INT NOT NULL,
    typ VARCHAR(20),
    zameranie VARCHAR(20)
);

CREATE TABLE Vybavenie (
    id_vybavenia INT PRIMARY KEY NOT NULL,
    nazov CHAR(20) NOT NULL,
    cena DECIMAL(10,2) NOT NULL,
    datum_kupy DATE,
    id_miestnosti VARCHAR(20) NOT NULL
);

ALTER TABLE Rezervacia ADD CONSTRAINT FK_Rezervacia_uzivatel FOREIGN KEY (id_uzivatela) REFERENCES 
Uzivatel;
ALTER TABLE Rezervacia ADD CONSTRAINT FK_Rezervacia_miestnosti FOREIGN KEY (id_miestnosti) REFERENCES 
Miestnost;
ALTER TABLE Vybavenie ADD CONSTRAINT FK_Vybavenie_miestnosti FOREIGN KEY (id_miestnosti) REFERENCES 
Miestnost;
ALTER TABLE Typ_rezervacie ADD CONSTRAINT FK_typ_rezervacie FOREIGN KEY (id_rezervacie) REFERENCES 
Rezervacia;

INSERT INTO UZIVATEL
VALUES ('xbarti01', 'Vladimir', 'Bartik', 'bartik@fit.vut.cz', 'bartik123', 'Garant');
INSERT INTO UZIVATEL
VALUES ('xsulos00', 'Samuel', 'Sulo', 'sulo@fit.vut.cz', 'sulos1234', 'Ucitel');
INSERT INTO UZIVATEL
VALUES ('xsadle01', 'Samuel', 'Sadlek', 'sadlek@fit.vut.cz', 'sadlek123', 'Ucitel');
INSERT INTO UZIVATEL
VALUES ('xligoc00', 'Marian', 'Ligocky', 'ligocky@fit.vut.cz', 'ligocky123', 'Ucitel');

INSERT INTO MIESTNOST
VALUES ('E112', '1.poschodie', 150, 'Ucebna', NULL);
INSERT INTO MIESTNOST
VALUES ('D105', '1.poschodie', 300, 'Ucebna', NULL);
INSERT INTO MIESTNOST
VALUES ('D205', '2.poschodie', 300, 'Ucebna', NULL);
INSERT INTO MIESTNOST
VALUES ('N105', '1.poschodie', 300, 'Laboratorium', 'pocitacove');

INSERT INTO VYBAVENIE
VALUES (124001, 'Stolicka', 10.2, DATE '2020-12-04', 'E112');
INSERT INTO VYBAVENIE
VALUES (124002, 'Stol', 50.2, DATE '2020-12-04', 'E112');
INSERT INTO VYBAVENIE
VALUES (124003, 'Stolicka', 10.5, DATE '2020-12-04', 'D105');
INSERT INTO VYBAVENIE
VALUES (124004, 'Stol', 100.5, DATE '2020-12-04', 'D105');
INSERT INTO VYBAVENIE
VALUES (124005, 'Tabula', 500, DATE '2020-12-04', 'N105');

INSERT INTO REZERVACIA
VALUES (141, 'Dlhodoby', '10:00', '12:50', NULL, 'Utorok', 'xbarti01', 'E112');
INSERT INTO REZERVACIA
VALUES (142, 'Dlhodoby', '10:00', '12:50', NULL, 'Utorok', 'xsulos00', 'D205');
INSERT INTO REZERVACIA
VALUES (143, 'Jednorazovy', '13:00', '15:50', DATE '2021-08-04', 'Streda', 'xbarti01', 'D105');
INSERT INTO REZERVACIA
VALUES (144, 'Jednorazovy', '15:00', '17:50', DATE '2021-10-02', 'Štvrtok', 'xsadle01', 'N105');
INSERT INTO REZERVACIA
VALUES (145, 'Jednorazovy', '08:00', '10:00', DATE '2021-10-02', 'Štvrtok', 'xsadle01', 'E112');
INSERT INTO REZERVACIA
VALUES (146, 'Jednorazovy', '10:00', '12:00', DATE '2021-09-21', 'Pondelok', 'xsulos00', 'D205');

INSERT INTO TYP_REZERVACIE
VALUES (141, 'Prednaskova', 'IDS', 'BIT', 2, NULL, NULL, NULL);
INSERT INTO TYP_REZERVACIE
VALUES (142, 'Prednaskova', 'IZG', 'BIT', 2, NULL, NULL, NULL);
INSERT INTO TYP_REZERVACIE
VALUES (143, 'Prednaskova', 'IMA2', 'BIT', 2, NULL, NULL, NULL);
INSERT INTO TYP_REZERVACIE
VALUES (144, 'Seminarova', 'IZG', 'BIT', 2, NULL, 'grafika', NULL);
INSERT INTO TYP_REZERVACIE
VALUES (145, 'Skuskova', 'IMA2', 'BIT', 2, 'riadny termín', NULL, NULL);
INSERT INTO TYP_REZERVACIE
VALUES (146, 'Mimoskolska', 'IMA2', 'BIT', 2, NULL, NULL, 'Imatrikuly');

-- Počet rezervácii uživateľov (Využitie GROUP BY a agregačnej funkcie COUNT)
SELECT Rezervacia.id_uzivatela, COUNT(Rezervacia.id_rezervacie) FROM Rezervacia
GROUP BY Rezervacia.id_uzivatela;

-- Suma vybavenia v miestnostiach zoradená od največšej (Využitie GROUP BY a agregačnej funkcie SUM)
SELECT Vybavenie.id_miestnosti, SUM(Vybavenie.cena) FROM Vybavenie
GROUP BY Vybavenie.id_miestnosti
ORDER BY SUM(Vybavenie.cena) DESC;

-- Vypis miestností, kde existuje vybavenie drahšie ako 100 (Prepojenie 2 tabuliek s využitím EXISTS)
SELECT Miestnost.id_miestnosti FROM Miestnost
WHERE EXISTS(SELECT Vybavenie.id_vybavenia FROM Vybavenie
            WHERE Vybavenie.id_miestnosti = Miestnost.id_miestnosti AND Vybavenie.cena > 100);

-- Výpis všetkych uživateľov, ktorí majú vytvorenú rezerváciu (Prepojenie 2 tabuliek)
SELECT * FROM Uzivatel
WHERE Uzivatel.id_uzivatela IN (SELECT Rezervacia.id_uzivatela FROM Rezervacia);

-- Výpis uživateľov s jednorázovou rezerváciou na dátum 2021-08-04 (Prepojenie 3 tabuliek)
SELECT Uzivatel.* FROM Uzivatel
JOIN Rezervacia ON Uzivatel.id_uzivatela = Rezervacia.id_uzivatela
JOIN Typ_rezervacie ON Rezervacia.id_rezervacie = Typ_rezervacie.id_rezervacie
WHERE Rezervacia.typ = 'Jednorazovy' AND datum = DATE '2021-08-04';



-- 1.trigger, aktualizuje id_uzivatela v Rezervácii
CREATE OR REPLACE TRIGGER aktualizuj_rezervaciu
    AFTER UPDATE OF id_uzivatela ON Uzivatel
    FOR EACH ROW
BEGIN
    UPDATE Rezervacia SET id_uzivatela = :NEW.id_uzivatela
    WHERE id_uzivatela = :OLD.id_uzivatela;
END;
/

UPDATE Uzivatel SET id_uzivatela = 'xupdat00' WHERE id_uzivatela = 'xsulos00';

-- 2.trigger, aktualizuje id_miestnosti v Rezervácii a vo Vybavení
CREATE OR REPLACE TRIGGER Aktualizuj_miestnost
    AFTER UPDATE OF id_miestnosti ON Miestnost
    FOR EACH ROW
BEGIN
    Update Vybavenie SET ID_MIESTNOSTI = :NEW.id_miestnosti
    WHERE id_miestnosti = :OLD.id_miestnosti;
    UPDATE Rezervacia SET id_miestnosti = :NEW.id_miestnosti
    WHERE id_miestnosti = :OLD.id_miestnosti;
    END;
/

UPDATE Miestnost Set id_miestnosti = 'E120' where id_miestnosti = 'E112';


-- 1.procedúra nájde vybavenie podľa zadaného ID Miestnosti
CREATE OR REPLACE PROCEDURE najdi_vybavenie(id_miestnosti_in VARCHAR) IS
    vybavenie_meno Vybavenie.nazov%TYPE;
    id_miestnosti Vybavenie.id_miestnosti%TYPE;
    cnt INT;

    CURSOR vybav IS
        SELECT nazov, id_miestnosti FROM Vybavenie
        WHERE Vybavenie.id_miestnosti = id_miestnosti_in;

BEGIN
    OPEN vybav;
    LOOP
        FETCH vybav INTO vybavenie_meno, id_miestnosti;
        EXIT WHEN vybav%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vybavenie_meno);
        cnt := 1;
    END LOOP;

    IF (cnt IS NULL) THEN
        BEGIN
            DBMS_OUTPUT.PUT_LINE('V danej miestnosti není žiadne vybavenie');
        END;
    END IF;
END;
/

BEGIN
    najdi_vybavenie('E112');
END;
/

-- 2.procedŕa nájde miestnosti podľa zadaného Typu rezervácie
CREATE OR REPLACE PROCEDURE najdi_miestnosti(typ_rezervacie_in VARCHAR) IS
    typ_var Typ_rezervacie.typ%TYPE;
    miestnost_meno Rezervacia.id_miestnosti%TYPE;
    cnt INT;

    CURSOR miest IS
        SELECT id_miestnosti, Typ_rezervacie.typ FROM Typ_rezervacie
            INNER JOIN Rezervacia ON Typ_rezervacie.id_rezervacie = Rezervacia.id_rezervacie
        WHERE Typ_rezervacie.typ = typ_rezervacie_in;

BEGIN
    OPEN miest;
    LOOP
        FETCH miest INTO miestnost_meno, typ_var;
        EXIT WHEN miest%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(miestnost_meno);
        cnt := 1;
    END LOOP;

    IF (cnt IS NULL) THEN
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Pre daný typ rezervácie neboli nájdené žiadne miestnosti.');
        END;
    END IF;
END;
/


BEGIN
    najdi_miestnosti('Prdnaskova');
END;
/


-- Explain plan
EXPLAIN PLAN FOR
SELECT miesto, COUNT(id_vybavenia) AS pocet
FROM Miestnost
    INNER JOIN Vybavenie ON Miestnost.id_miestnosti = Vybavenie.id_miestnosti
GROUP BY miesto
ORDER BY pocet;

SELECT * FROM TABLE(dbms_xplan.display);

CREATE INDEX explain_index ON Vybavenie(id_miestnosti);

EXPLAIN PLAN FOR
SELECT miesto, COUNT(id_vybavenia) AS pocet
FROM Miestnost
    INNER JOIN Vybavenie ON Miestnost.id_miestnosti = Vybavenie.id_miestnosti
GROUP BY miesto
ORDER BY pocet;

SELECT * FROM TABLE(dbms_xplan.display);

------------------------------------------------
GRANT ALL ON Uzivatel TO XSADLE01;           -- 1. používateľ udeľuje práva druhému
GRANT ALL ON Rezervacia TO XSADLE01;
GRANT ALL ON Typ_rezervacie TO XSADLE01;
GRANT ALL ON Miestnost TO XSADLE01;
GRANT ALL ON Vybavenie TO XSADLE01;
GRANT ALL ON materialized_view TO XSULOS00; -- 2. používateľ udeľuje práva prvému
------------------------------------------------

-- Materializovaný pohľad, kde druhý použivateľ naplní tabuľky datami a prvý použivateľ ich vypíše
-- 2. používateľ
INSERT INTO XSULOS00.MIESTNOST VALUES ('E113', '1.poschodie', 150, 'Ucebna', NULL);
--DELETE FROM Miestnost WHERE Miestnost.id_miestnosti = 'E113';
INSERT INTO XSULOS00.VYBAVENIE VALUES (124007, 'Stol', 50.2, DATE '2020-12-04', 'E113');
--DELETE FROM Vybavenie WHERE Vybavenie.id_vybavenia = 124007;

CREATE MATERIALIZED VIEW materialized_view AS
SELECT Vybavenie.id_miestnosti, SUM(Vybavenie.cena) FROM Vybavenie
GROUP BY Vybavenie.id_miestnosti
ORDER BY SUM(Vybavenie.cena) DESC;

-- 1. používateľ
SELECT * FROM materialized_view;
