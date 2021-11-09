CREATE OR REPLACE procedure PrintNDep(
  numDep in int,n in int)
IS
CURSOR CR IS 
  select *
    from employees
   where DEPARTMENT_ID=numDep
   OFFSET 0 ROWS FETCH NEXT n ROWS ONLY;
numeroTot int(4);
begin
select count(*)
  into numeroTot
  from employees
 where DEPARTMENT_ID=numDep;
if SQL%NOTFOUND then
dbms_output.put_line('departement not found');
else
if numeroTot<n then
dbms_output.put_line('n > a la nombre des employee de cette departement');
else
for emp_rec in CR loop
dbms_output.put_line('name :'|| emp_rec.FIRST_NAME||' '|| emp_rec.LAST_NAME ||' Email: '||emp_rec.EMAIL  ||' Salaire:'||emp_rec.SALARY);
end loop;
end if; 
end if;
end;
/