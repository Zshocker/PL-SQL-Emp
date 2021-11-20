/*CREATE SEQUENCE EtudiantSeq INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE ModSeq INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE ExamSeq INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE PreqSeq INCREMENT BY 1 START WITH 1;
CREATE TABLE ETUDIANT 
(
  numEtud number(4) NOT NULL PRIMARY KEY,
  nom VARCHAR2(25),
  prenom VARCHAR2(25),
  datenaiss DATE,
  civilite VARCHAR2(4) CHECK(civilite IN('Mr','Mme','Mlle')),
  numsecu number(3) not NULL
);
CREATE  TABLE MODULE 
(
  codMod number(4) NOT NULL PRIMARY KEY,
  nomMod VARCHAR2(25),
  effecMax NUMBER(3) DEFAULT 30
);
CREATE TABLE EXAMEN 
(
    codMod number(4) REFERENCES MODULE(codMod),
    codeExam number(4) NOT NULL PRIMARY KEY,
    dateExam DATE 
);
CREATE TABLE INSCRIPTION
(
    codMod number(4) REFERENCES MODULE(codMod),
    numEtud number(4) REFERENCES ETUDIANT(numEtud),
    dateInsc DATE DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT Ins_pk PRIMARY KEY (codMod, numEtud)
);

CREATE TABLE PREREQUIS 
(
    codMod number(4) REFERENCES MODULE(codMod),
    codModPrereq number(4) NOT NULL PRIMARY KEY,
    noteMin number(2) not NULL 
);
CREATE TABLE Resultat 
(
    codMod number(4) REFERENCES MODULE(codMod),
    codeExam number(4) REFERENCES EXAMEN(codeExam),
    numEtud number(4) REFERENCES ETUDIANT(numEtud),
    note number(4,2),
    CONSTRAINT Res_pk PRIMARY KEY (codMod,codeExam,numEtud)
);*/

/*
CREATE OR REPLACE TRIGGER Const_Min
  BEFORE UPDATE ON PREREQUIS
  FOR EACH ROW
  WHEN (old.noteMin!=new.noteMin)
  BEGIN
    RAISE_APPLICATION_ERROR(-20000,'no mod on note min');
  END Const_Min;    
/

CREATE OR REPLACE TRIGGER effect_max_Insc
  BEFORE INSERT ON INSCRIPTION
  FOR EACH ROW
  DECLARE
  numEtudi int(4);
  maxe int(4);
  BEGIN
    SELECT count(*)
    into numEtudi
    FROM INSCRIPTION
    WHERE codMod=:new.codMod;
    SELECT
    EFFECMAX
    INTO maxe
    FROM MODULE
    WHERE CODMOD = :new.codMod;
    IF numEtudi>=maxe THEN 
    RAISE_APPLICATION_ERROR(-20001,'effect max attent');
    END IF;
  END effect_max_Insc;
/
CREATE OR REPLACE TRIGGER EXAMEN_Con 
  BEFORE INSERT ON EXAMEN
  FOR EACH ROW
  DECLARE
  num int(4):=0;
  BEGIN
    SELECT COUNT(*)
    into num
    FROM INSCRIPTION
    WHERE CODMOD=:new.codMod;
  if num=0 THEN
  RAISE_APPLICATION_ERROR(-20002,'Can`t Do that');
  END IF;
  END EXAMEN_Con;
/*
CREATE OR REPLACE TRIGGER pass_exam
  BEFORE INSERT ON RESULTAT
  FOR EACH ROW
  DECLARE 
  dateInsce DATE;
  DateExa DATE;
  BEGIN
  SELECT DATEEXAM
  into DateExa
  FROM EXAMEN
  WHERE CODEEXAM=:new.CODEEXAM;
  SELECT dateInsc
  into dateInsce
  FROM INSCRIPTION
  WHERE numEtud=:new.numEtud and CODMOD=:new.CODMOD;
  IF dateInsce>DateExa THEN
  RAISE_APPLICATION_ERROR(-20003,'Un élève ne peut passer un examen que si sa date d’inscription est antérieure à la date de l’examen!!');
  END IF;
  END pass_exam;
/
SHOW ERRORS;
CREATE OR REPLACE VIEW Etutiant_INSCRI AS (SELECT NUMETUD,CODMOD,nom FROM ETUDIANT NATURAL JOIN INSCRIPTION);
CREATE OR REPLACE VIEW Etudiant_Avg AS (SELECT NUMETUD,nom,AVG(NOTE) as AVERAGEs FROM  (SELECT I.NUMETUD,nom,NOTE FROM Etutiant_INSCRI I JOIN RESULTAT R ON I.NUMETUD=R.NUMETUD and I.CODMOD=R.CODMOD) GROUP BY NUMETUD,nom);
CREATE OR REPLACE TRIGGER Const_Min
  BEFORE UPDATE ON PREREQUIS
  FOR EACH ROW
  WHEN (old.noteMin!=new.noteMin)
  DECLARE
  numEQ int(4):=0;
  BEGIN
    select count(*)
    into numEQ
    from INSCRIPTION
    WHERE CODMOD=:new.codMod;
    IF numEQ>0 THEN 
    RAISE_APPLICATION_ERROR(-20000,'no mod on note min');
    END IF;
  END Const_Min;    
/*/
CREATE OR REPLACE TRIGGER Const_Effec_MAx
  BEFORE UPDATE ON MODULE
  FOR EACH ROW
  WHEN (old.effecMax!=new.effecMax)
  DECLARE
  numEQ int(4):=0;
  BEGIN
    select count(*)
    into numEQ
    from INSCRIPTION
    WHERE CODMOD=:old.codMod;
    IF numEQ>0 THEN 
    RAISE_APPLICATION_ERROR(-20000,'no mod on effect max');
    END IF;
  END Const_Effec_MAx;   
/ 