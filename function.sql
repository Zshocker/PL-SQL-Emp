CREATE OR REPLACE FUNCTION insert_emp(
    FIRST_N in VARCHAR2,
    LAST_N in VARCHAR2,
    EMAI IN VARCHAR2 ,
    PHONE in VARCHAR2,
    JOB in VARCHAR2 ,
    SALAR in NUMBER,
    COMMISSION in NUMBER,
    MANAGER in NUMBER ,
    DEPARTMENT in NUMBER)
return number
IS
someVal int(4):=EMPLOYEES_SEQ.NEXTVAL;
vars VARCHAR2(25):=TO_CHAR(CURRENT_DATE());
BEGIN
INSERT INTO EMPLOYEES(
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    PHONE_NUMBER,
    HIRE_DATE,
    JOB_ID,
    SALARY,
    COMMISSION_PCT,
    MANAGER_ID,
    DEPARTMENT_ID
  )
VALUES
  (
    someVal,
    FIRST_N,
    LAST_N,
    EMAI,
    PHONE,
    vars,
    JOB,
    SALAR,
    COMMISSION,
    MANAGER,
    DEPARTMENT
  );
return someVal;
END insert_emp;
/
CREATE OR REPLACE function max_sal_job(
  job in varchar2   
) return number
IS 
maxe number(6);
begin
  select max(SALARY)
    into maxe
    from Employees
   where JOB_ID =(SELECT JOB_ID from JOBS where JOB_TITLE=job or JOB_ID=job);
   if SQL%NOTFOUND then
  dbms_output.put_line('JOB not found');
  end if;
    return maxe;   
end max_sal_job;
/
CREATE OR REPLACE FUNCTION dep_nbrempe(
  numDep in number)
RETURN number
IS
outnbremp number(3);
BEGIN
select count(*)
  into outnbremp
  from employees
 where DEPARTMENT_ID=numDep;
if SQL%NOTFOUND then
dbms_output.put_line('departement not found');
end if;
return outnbremp;
END dep_nbrempe;
/
VARIABLE max_sal number;
EXECUTE :max_sal:=max_sal_job('SA_MAN');
PRINT max_sal;
VARIABLE cptemp  number;
EXECUTE :cptemp:=dep_nbrempe(90);
PRINT cptemp; 