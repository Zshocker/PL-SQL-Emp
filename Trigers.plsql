CREATE OR REPLACE TRIGGER check_salary
  BEFORE INSERT ON employees
  FOR EACH ROW
  WHEN (new.SALARY<5000)
  BEGIN
  :new.Salary:=5000;
  END check_salary;
/
CREATE OR REPLACE TRIGGER employe_embauche
  BEFORE INSERT ON EMPLOYEES
  FOR EACH ROW
  BEGIN
  IF (TO_DATE(:new.HIRE_DATE)> CURRENT_DATE()) THEN
  RAISE_APPLICATION_ERROR(-20000,'La date d’embauche est supérieure à la date système');
  END IF;
  END employe_embauche;
/
CREATE OR REPLACE TRIGGER verfi_sal
  BEFORE INSERT OR UPDATE ON EMPLOYEES
  FOR EACH ROW
  WHEN (new.JOB_ID!='AD_PRES')
  DECLARE
  minmum JOBS.MIN_SALARY%TYPE;
  maximum JOBS.MAX_SALARY%TYPE;
  BEGIN
  SELECT MIN_SALARY,MAX_SALARY
  INTO minmum,maximum
  FROM JOBS
  WHERE JOB_ID=:new.JOB_ID;
  IF (:new.SALARY <minmum OR :new.SALARY> maximum) THEN
  RAISE_APPLICATION_ERROR(-20001,'OUT OF RANGE');
  END IF;
  END verfi_sal;
/
CREATE OR REPLACE TRIGGER ModHistory
  AFTER INSERT OR DELETE OR UPDATE ON EMPLOYEES
  FOR EACH ROW
  DECLARE
  typeMod VARCHAR2(40);
  Dat DATE;
  Emp int(4):=:old.EMPLOYEE_ID;
  BEGIN
  Dat:=CURRENT_DATE();
  IF DELETING THEN 
  typeMod:='Delete';
  ELSIF INSERTING THEN 
  typeMod:='Insert';
  Emp:=:new.EMPLOYEE_ID;
  ELSIF UPDATING THEN
  typeMod:='Update';
  END IF;
  INSERT INTO History 
  VALUES
  (
    Emp,
    Dat,
    typeMod
  );
  END ModHistory;
/