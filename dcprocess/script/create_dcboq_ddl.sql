-- create_dcboq_ddl.sql
-- (c) 2004 DORSCH Consult

drop table IndividualPosition;
drop view DciFitting;
drop view MixedFitting;
drop view PeFitting;

create table IndividualPosition (
  dc_oid varchar(32), 
  quantity integer, 
  unit varchar(8),
  material varchar(4),
  description varchar(128)
  );
  
create or replace view DciFitting as select dc_id, Connection, DN1, DN2, DN3 
  from Fitting
  where (DN1 >= 80 and DN2 >= 80 and DN3 >= 80) or
  (DN1 >= 80 and DN2 >= 80 and DN3 is null) or
  (DN1 >= 80 and DN2 is null and DN3 is null);
  
create or replace view MixedFitting as select dc_id, Connection, DN1, DN2, DN3 
  from Fitting
  where DN1 >= 80 and DN2 < 80 and (DN3 < 80 or DN3 is null);

create or replace view MixedFitting2 as select dc_id, Connection, DN1, DN2, DN3
  from Fitting
  where DN1 >= 80 and DN2 >= 80 and DN3 < 80;

create or replace view PeFitting as select dc_id, Connection, DN1, DN2, DN3 from 
  Fitting
  where DN1 < 80;
  
create or replace view PositionView as select Description, Material, Unit, 
  sum(quantity) as quantity 
  from IndividualPosition group by Description, Material, Unit 
  order by Material, Description;  
