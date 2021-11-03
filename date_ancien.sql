VARIABLE date_ans varchar2(25);
Declare
begin
select min(HIRE_DATE)
  into :date_ans
  from employees;
end;
/
PRINT date_ans;