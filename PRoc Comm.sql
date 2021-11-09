CREATE OR REPLACE procedure Comm_employe(
  num in int,taux in float)
IS
begin
update employees
   set COMMISSION_PCT=COMMISSION_PCT*taux
 where COMMISSION_PCT is not NULL and EMPLOYEE_ID=num; 
if SQL%NOTFOUND then
dbms_output.put_line('employee doesnt exist or the commission is null!');
end if;
end;
/