CREATE OR REPLACE procedure BackUp(
  tablee in varchar2)
IS
newTab varchar2(25);
begin
newTab:='Vue_'||tablee;
execute immediate 'insert into '||newTab || '( select * from '||tablee||' )';
end;
/