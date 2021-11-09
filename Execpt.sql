ACCEPT mate PROMPT 'Donner Matricule : ';
Declare
Type Rec is RECORD(FIRST_NAME employees.FIRST_NAME%TYPE,LAST_NAME employees.LAST_NAME%TYPE,SALARY employees.SALARY%TYPE,DEPARTMENT_NAME DEPARTMENTS.DEPARTMENT_NAME%TYPE);
ID_empty exception;
mat varchar2(25):='&mate';
emp_rec Rec;
PRAGMA EXCEPTION_INIT(myExec,-2292);  
begin
if mat is NULL then
  raise ID_empty;
end if;
select FIRST_NAME,LAST_NAME,SALARY,DEPARTMENT_NAME
  into emp_rec
  from employees E JOIN DEPARTMENTS D ON  E.DEPARTMENT_ID=D.DEPARTMENT_ID
 where EMPLOYEE_ID=mat; 
dbms_output.put_line('numero :'||mat ||CHR(10) ||'name :'||
                     emp_rec.FIRST_NAME||' '|| emp_rec.LAST_NAME||
                     CHR(10)||'Salaire :'||emp_rec.SALARY||CHR(10)||'DEPARTEMENT NAME :'||emp_rec.DEPARTMENT_NAME);
exception
  when no_data_found then
    dbms_output.put_line('employé n’existe pas');
  when ID_empty then 
    dbms_output.put_line('please enter a value');
end;
/