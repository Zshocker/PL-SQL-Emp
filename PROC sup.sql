CREATE OR REPLACE procedure supprimer_employer(
  num in int)
IS
myExec exception;
PRAGMA EXCEPTION_INIT(myExec,-2292);  
begin
delete from employees
where EMPLOYEE_ID=num;
if SQL%NOTFOUND then
dbms_output.put_line('employee doesnt exist!');
end if;
exception
  when myExec then
    dbms_output.put_line('cannot delete Employee while He is a in another table!');
end;
/