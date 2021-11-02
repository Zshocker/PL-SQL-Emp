ACCEPT mat PROMPT 'Donner Matricule : ';
Declare
new_Salaire Int(4):=&new_Salaire;
new_Email varchar2(50):=&new_Email;
emp_rec employees%ROWTYPE;
begin
select *
  into emp_rec
  from employees
 where EMPLOYEE_ID=&mat; 
dbms_output.put_line('Old Info'||CHR(10) ||'name :'|| emp_rec.FIRST_NAME||' '|| emp_rec.LAST_NAME||CHR(10) ||'Email: '||emp_rec.EMAIL  ||CHR(10) ||'Salaire:'||emp_rec.SALARY);
IF new_Salaire>5000 Then
update employees
   set SALARY=new_Salaire
 where EMPLOYEE_ID=&mat;
END IF;
update employees
   set Email=new_Email
 where EMPLOYEE_ID=&mat;
end;
/