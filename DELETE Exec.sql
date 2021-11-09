ACCEPT mate PROMPT 'Donner le numero de departement a supprimer';
Declare
ID_empty exception;
id_Dep varchar2(25):='&mate';
myExec exception;
PRAGMA EXCEPTION_INIT(myExec,-2292);  
begin
if id_Dep is NULL then
  raise ID_empty;
end if;
delete from DEPARTMENTS
 where DEPARTMENT_ID=id_Dep;
 if SQL%NOTFOUND then
    dbms_output.put_line('Departement doesnt exist!');
 end if;
exception
  when myExec then
    dbms_output.put_line('cannot delete departement while there is employees working in it!');
  when ID_empty then 
    dbms_output.put_line('please enter a value');
end;
/