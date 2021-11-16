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
--Create a new Table Trigger

CREATE OR REPLACE TRIGGER Const_Min
  BEFORE UPDATE ON PREREQUIS
  FOR EACH ROW
  WHEN (old.noteMin!=new.noteMin)
  BEGIN
    RAISE_APPLICATION_ERROR(-20000,'no mod on note min');
  END Const_Min;    
/
--Create a new Table Trigger

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
Show ERRORS;