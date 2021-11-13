CREATE OR REPLACE procedure BackUp(
  tablee in varchar2)
IS
newTab varchar2(25);
SQa varchar2(75);
begin
newTab:='Vue_'||tablee;
SQa:='create view '||newTab || ' as ( select * from '||tablee||' )';
execute immediate SQa;
end;
/