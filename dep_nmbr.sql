CREATE OR REPLACE procedure dep_nbremp (
  numDep in int,outnbremp out number)
IS
begin
select count(*)
  into outnbremp
  from employees
 where DEPARTMENT_ID=numDep;
if SQL%NOTFOUND then
dbms_output.put_line('departement not found');
end if;
end;
/