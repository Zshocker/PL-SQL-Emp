---1)
ACCEPT nomDis PROMPT 'Donner nom de Disk';
DECLARE
CURSOR CR IS
SELECT nomPartition,nomF,type,datecreation
FROM PARTITION JOIN FICHIER ON nomP=nomPartition
WHERE nomDisque=&nomDis;
Rec FICHIER%ROWTYPE;
test VARCHAR2(25);
BEGIN
SELECT nomD
into test
from DISQUE where nomD=&nomDis;
OPEN CR
LOOP
    FETCH CR INTO Rec
    EXIT WHEN CR%NOTFOUND;
    dbms_output.put_line('&nomDis/'||Rec.nomPartition||' / '|| Rec.nomF|| ' type :'||Rec.type|| ' date de creation'|| TOCHAR(Rec.datecreation));
end LOOP;
if CR%ROWCOUNT < 1 THEN 
dbms_output.put_line('le disk est vide');
END IF;
CLOSE CR;
EXCEPTION
WHEN no_data_found THEN
dbms_output.put_line('le disk n existe pas');
END;
/
CREATE OR REPLACE PROCEDURE VUE_FICHEIR_DISK (
  nomDis IN varchar2) IS
  varSum NUMBER;
BEGIN
EXECUTE IMMEDIATE 'CREATE OR REPLACE View Ficher_Disk_'||nomDis||' AS (SELECT nomDisque,nomPartition,nomF,type,datecreation FROM PARTITION JOIN FICHIER ON nomP=nomPartition WHERE nomDisque='||nomDis||')';
END VUE_FICHEIR_DISK;
/
CREATE or REPLACE TRIGGER PARTITION_Dis
  BEFORE INSERT ON PARTITION
  FOR EACH ROW
  DECLARE
  sumE number(12);
  disqspace number(12);
  BEGIN
  select capacite,sum(taille)
  into diskspace,sumE
  FROM DIsque JOIN PARTITION ON nomD=nomDisque 
  WHERE nomD=:new.nomDisque;
  sumE:=sumE+:new.taille;
    if sumE > disqspace then 
    RAISE_APPLICATION_ERROR(-20000,'not enough space');
    end IF;
  END PARTITION_Dis;
/
CREATE OR REPLACE FUNCTION Taille_plein_Part(
nomPar in NUMBER
)
RETURN number
IS
esp PARTITION.taille%TYPE;
BEGIN
select sum(espace_occupe)
into esp
FROM FICHIER where nomPar=nomPar;
RETURN esp;
END;
/
CREATE OR REPLACE FUNCTION Taille_Libre_Part(
nomPar in NUMBER
)
RETURN number
IS
taillePar PARTITION.taille%TYPE;
esp PARTITION.taille%TYPE;
tailleLibre PARTITION.taille%TYPE;
BEGIN
select taille,sum(espace_occupe)
into taillePar,esp
FROM PARTITION JOIN FICHIER ON nomP=nomPartition where nomP=nomPar;
tailleLibre :=taillePar-esp;
RETURN tailleLibre;
END;
/
VARIABLE esplib PARTITION.taille%TYPE;
EXECUTE :esplib:=Taille_Libre_Part('D');
PRINT esplib;
--5)
SELECT * FROM USER_OBJECTS WHERE name='Taille_Libre_Part';
CREATE OR REPLACE PROCEDURE Copie_Partis (
  nomPartDest IN varchar2
  nomPartSource IN varchar2
) IS
  DestVide PARTITION.taille%TYPE;
  SourcePlein PARTITION.taille%TYPE;
  CURSOR CR IS
  SELECT *
  From FICHIER 
  WHERE nomPartition=nomPartSource;
  Rec FICHIER%ROWTYPE;
BEGIN
    DestVide:=Taille_Libre_Part(nomPartDest);
    SourcePlein:=Taille_plein_Part(nomPartSource);
    IF DestVide<SourcePlein THEN 
    RAISE_APPLICATION_ERROR(-20001,'Espace insuffisant');
    END IF;
    OPEN CR
    LOOP
        FETCH CR INTO Rec
        EXIT WHEN CR%NOTFOUND;
        insert into FICHIER VALUES(Rec.nomPartition,Rec.nomF,Rec.type,Rec.espace_occupe,Rec.datecreation,Rec.datederniermodif);
    end LOOP;
    COMMIT;
END Copie_Partis;
/