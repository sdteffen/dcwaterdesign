-- create_dcboq_ddl.sql
-- (c) 2004 DORSCH Consult

drop table IndividualPosition;
drop view PeFitting;

create table IndividualPosition (
  dc_oid varchar(32), 
  quantity integer, 
  unit varchar(8),
  material varchar(4),
  description varchar(128)
  );
  
create or replace view PeFitting as select dc_id, Connection, DN1, DN2, DN3 from 
  Fitting
  where DN1 < 600;
  
create or replace view PositionView as select Description, Material, Unit, 
  sum(quantity) as quantity 
  from IndividualPosition group by Description, Material, Unit 
  order by Material, Description;  
