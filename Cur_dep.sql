DECLARE 
CURSOR CR IS 
  select D.DEPARTMENT_ID,DEPARTMENT_NAME,sum(SALARY) as massSa
  from employees  E JOIN DEPARTMENTS  D ON  D.DEPARTMENT_ID=E.DEPARTMENT_ID
  where D.DEPARTMENT_ID IS NOT NULL AND D.DEPARTMENT_ID!=30
 group by D.DEPARTMENT_ID,DEPARTMENT_NAME
 having count(*)=
 (select count(*)
   from employees
  where DEPARTMENT_ID=30);
DEP_REC CR%ROWTYPE;
begin
  OPEN CR;
  loop
    FETCH CR into Dep_rec;
    exit when CR%NOTFOUND;
    dbms_output.put_line(Dep_rec.DEPARTMENT_ID||' / '|| Dep_rec.DEPARTMENT_NAME||' / '||Dep_rec.massSa);
  end loop;
end;
/