-- fitting_boq.sql
-- (c) 2004, 2005 DORSCH Consult

delete from IndividualPosition;

-- Detail 11
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI', 
  'Socket Reducer ' || DN1 || '/' || DN2 from DciFitting where connection = 11);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Spigot ' || DN2 from MixedFitting where connection = 11);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN2 from MixedFitting where connection = 11);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where connection = 11);

insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Reducer ' || DN1 || '/' || DN2 from PeFitting where connection = 11);
  
-- Detail 21
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Socket Tee ' || DN1 || '/' || DN2 from DciFitting where connection=21);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Tee with Flanged Branch ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 21);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 21);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 || '/' || DN2 from PeFitting where
  connection = 21);
  
-- Detail 22
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Tee with Flanged Branch ' || DN1 || '/' || DN2 from DciFitting where
  connection = 22);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 22);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from DciFitting where
  connection = 22);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Tee with Flanged Branch ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 22);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 22);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 22);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 || '/' || DN2 from PeFitting where
  connection = 22);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from PeFitting where
  connection = 22);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from PeFitting where
  connection = 22);

-- Detail 23
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from DciFitting where
  connection = 23);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from DciFitting where
  connection = 23);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 23);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from DciFitting where
  connection = 23);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from DciFitting where
  connection = 23);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 23);

  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 23);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from MixedFitting where
  connection = 23);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 23);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from MixedFitting where
  connection = 23);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 23);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 23);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 || '/' || DN2 from PeFitting where
  connection = 23);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from PeFitting where
  connection = 23);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from PeFitting where
  connection = 23);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN1 from PeFitting where
  connection = 23);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from PeFitting where
  connection = 23);

-- Detail 24
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from DciFitting where
  connection = 24);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 24);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from DciFitting where
  connection = 24);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 24);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from DciFitting where
  connection = 24);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 24);  

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 24);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 24);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from MixedFitting where
  connection = 24);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 24);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from MixedFitting where
  connection = 24);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 24);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 || '/' || DN2 from PeFitting where
  connection = 24);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from PeFitting where
  connection = 24);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from PeFitting where
  connection = 24);
insert into IndividualPosition (select dc_id, 4, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN1 from PeFitting where
  connection = 24);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from PeFitting where
  connection = 24);  
  
-- Detail 25
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from DciFitting where
  connection = 25);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from DciFitting where
  connection = 25);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 25);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN2 from DciFitting where
  connection = 25);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from DciFitting where
  connection = 25);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 25);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from MixedFitting where
  connection = 25);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from MixedFitting where
  connection = 25);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Socket ' || DN2 from MixedFitting where
  connection = 25);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 25);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 || '/' || DN2 from PeFitting where
  connection = 25);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from PeFitting where
  connection = 25);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN1 from PeFitting where
  connection = 25);

-- Detail 31
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Socket Tee ' || DN1 || '/' || DN2 from DciFitting where
  connection = 31);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 31);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 31);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 31);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 31);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 31);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 || '/' || DN2 from PeFitting where
  connection = 31);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Reducer ' || DN1 || '/' || DN2 from PeFitting where
  connection = 31);

-- Detail 32
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Tee with Flanged Branch ' || DN1 || '/' || DN2 from DciFitting where
  connection = 32);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 32);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from DciFitting where
  connection = 32);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer  ' || DN1 || '/' || DN2 from DciFitting where
  connection = 32);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 32);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 32);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 32);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 32);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 32);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 || '/' || DN2 from PeFitting where
  connection = 32);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from PeFitting where
  connection = 32);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Reducer ' || DN1 || '/' || DN2 from PeFitting where
  connection = 32);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Pushfit Adapter ' || DN2 from PeFitting where
  connection = 32);

-- Detail 33
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from DciFitting where
  connection = 33);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 33);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 33);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from DciFitting where
  connection = 33);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 33);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 33);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 33);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Gate Valve  ' || DN2 from MixedFitting where
  connection = 33);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 33);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 33);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 || '/' || DN2 from PeFitting where
  connection = 33);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from PeFitting where
  connection = 33);
insert into IndividualPosition (select dc_id, 4, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 33);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 33);

-- Detail 34
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from DciFitting where
  connection = 34);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 34);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 34);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer  ' || DN1 || '/' || DN2 from DciFitting where
  connection = 34);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN2 from DciFitting where
  connection = 34);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 34);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 34);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 34);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 34);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 34);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 || '/' || DN2 from PeFitting where
  connection = 34);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Reducer ' || DN1 || '/' || DN2 from PeFitting where
  connection = 34);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from PeFitting where
  connection = 34);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Pushfit Adapter ' || DN2 from PeFitting where
  connection = 34);

-- Detail 41
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Socket Tee ' || DN1 from DciFitting where
  connection = 41);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 from DciFitting where
  connection = 41);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Socket Tee ' || DN1 from MixedFitting where
  connection = 41);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Spigot ' || DN1 from MixedFitting where
  connection = 41);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 41);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 41);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1  from PeFitting where
  connection = 41);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Reducer ' || DN1 || '/' || DN2 from PeFitting where
  connection = 41);

-- Detail 42
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Tee with Flanged Branch ' || DN1 from DciFitting where
  connection = 42);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from DciFitting where
  connection = 42);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from DciFitting where
  connection = 42);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 42);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from MixedFitting where
  connection = 42);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from MixedFitting where
  connection = 42);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from MixedFitting where
  connection = 42);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 42);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 42);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 42);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 from PeFitting where
  connection = 42);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from PeFitting where
  connection = 42);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Pushfit Reducer ' || DN1 || '/' || DN2 from PeFitting where
  connection = 42);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from PeFitting where
  connection = 42);

-- Detail 43
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from DciFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from DciFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from DciFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from DciFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 43);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from MixedFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from MixedFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from MixedFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 43);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 from PeFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from PeFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from PeFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN1 from PeFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from PeFitting where
  connection = 43);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Reducer ' || DN1 || '/' || DN2 from PeFitting where
  connection = 43);

-- Detail 44
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from DciFitting where
  connection = 44);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from DciFitting where
  connection = 44);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 44);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from DciFitting where
  connection = 44);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from DciFitting where
  connection = 44);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 44);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from MixedFitting where
  connection = 44);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from MixedFitting where
  connection = 44);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from MixedFitting where
  connection = 44);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 44);  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 44);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 44);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 from PeFitting where
  connection = 44);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from PeFitting where
  connection = 44);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from PeFitting where
  connection = 44);  
insert into IndividualPosition (select dc_id, 4, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN1 from PeFitting where
  connection = 44);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from PeFitting where
  connection = 44);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Reducer ' || DN1 || '/' || DN2 from PeFitting where
  connection = 44);
  
-- Detail 51
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Socket Tee ' || DN1 from DciFitting where
  connection = 51);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 51);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from MixedFitting where
  connection = 51);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 51);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 51);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 51);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 from PeFitting where
  connection = 51);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Pushfit Reducer ' || DN1 || '/' || DN2 from PeFitting where
  connection = 51);

-- Detail 52
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from DciFitting where
  connection = 52);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 52);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 52);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 52);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from DciFitting where
  connection = 52);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from MixedFitting where
  connection = 52);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 52);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 52);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 52);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 52);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 from PeFitting where
  connection = 52);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Pushfit Reducer ' || DN1 || '/' || DN2 from PeFitting where
  connection = 52);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from PeFitting where
  connection = 52);
insert into IndividualPosition (select dc_id, 4, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from PeFitting where
  connection = 52);

-- Detail 61
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Socket Tee ' || DN1 from DciFitting where
  connection = 61);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 from PeFitting where
  connection = 61);
  
-- Detail 62
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Tee with Flanged Branch ' || DN1 from DciFitting where
  connection = 62);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from DciFitting where
  connection = 62);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from DciFitting where
  connection = 62);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 from PeFitting where
  connection = 62);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from PeFitting where
  connection = 62);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN1 from PeFitting where
  connection = 62);

-- Detail 63
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from DciFitting where
  connection = 63);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 63);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from DciFitting where
  connection = 63);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from DciFitting where
  connection = 63);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 from PeFitting where
  connection = 63);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Gate Valve ' || DN1 from PeFitting where
  connection = 63);
insert into IndividualPosition (select dc_id, 4, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN1 from PeFitting where
  connection = 63);
  
-- Detail 64
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from DciFitting where
  connection = 64);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 64);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from DciFitting where
  connection = 64);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from DciFitting where
  connection = 64);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 from PeFitting where
  connection = 64);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from PeFitting where
  connection = 64);
insert into IndividualPosition (select dc_id, 4, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN1 from PeFitting where
  connection = 64);

-- Detail 65
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from DciFitting where
  connection = 65);
insert into IndividualPosition (select dc_id, 2, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 65);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from DciFitting where
  connection = 65);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from DciFitting where
  connection = 65);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Tee ' || DN1 from PeFitting where
  connection = 65);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from PeFitting where
  connection = 65);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN1 from PeFitting where
  connection = 65);
 
-- Detail 71
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 71);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Blind Flange ' || DN1 from DciFitting where
  connection = 71);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit ' || DN1 from PeFitting where
  connection = 71);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Blind Flange ' || DN1 from PeFitting where
  connection = 71);
  
-- Detail 101
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Socket Tee ' || DN1 || '/' || DN2 from DciFitting where
  connection = 101);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN3 from DciFitting where
  connection = 101);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Socket Tee ' || DN1 || '/' || DN2 from MixedFitting2 where
  connection = 101);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN3 from MixedFitting2 where
  connection = 101);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Spigot ' || DN3 from MixedFitting2 where
  connection = 101);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Pushfit Adapter ' || DN3 from MixedFitting2 where
  connection = 101);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 101);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 101);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from MixedFitting where
  connection = 101);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting where
  connection = 101);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where connection = 101);

-- Detail 102
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Tee with Flanged Branch ' || DN1 || '/' || DN2 from DciFitting where
  connection = 102);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 102);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from DciFitting where
  connection = 102);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN3 from DciFitting where
  connection = 102);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from MixedFitting2 where
  connection = 102);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting2 where
  connection = 102);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting2 where
  connection = 102);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from MixedFitting2 where
  connection = 102);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from MixedFitting2 where
  connection = 102);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting2 where
  connection = 102);
 
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 102);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 102);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 102);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 102);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from MixedFitting where
  connection = 102);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting where
  connection = 102);

-- Detail 103
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from DciFitting where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from DciFitting where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from DciFitting where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN3 from DciFitting where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from DciFitting where
  connection = 103);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from MixedFitting2 where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting2 where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting2 where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from MixedFitting2 where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from MixedFitting2 where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from MixedFitting2 where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting2 where
  connection = 103);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from MixedFitting where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from MixedFitting where
  connection = 103);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting where
  connection = 103);

-- Detail 104
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from DciFitting where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from DciFitting where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from DciFitting where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from DciFitting where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from DciFitting where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN3 from DciFitting where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from DciFitting where
  connection = 104);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from MixedFitting2 where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from MixedFitting2 where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting2 where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from MixedFitting2 where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from MixedFitting2 where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from MixedFitting2 where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from MixedFitting2 where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting2 where
  connection = 104);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from MixedFitting where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from MixedFitting where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from MixedFitting where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from MixedFitting where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 104);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting where
  connection = 104);

-- Detail 111
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Socket Tee ' || DN1 || '/' || DN3 from DciFitting where
  connection = 111);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 111);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Tee with Flanged Branch ' || DN1 || '/' || DN3 from MixedFitting2 where
  connection = 111);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN2 from MixedFitting2 where
  connection = 111);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting2 where
  connection = 111);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN3 from MixedFitting where
  connection = 111);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 111);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 111);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 111);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting where
  connection = 111);

-- Detail 112
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Tee with Flanged Branch ' || DN1 || '/' || DN3 from DciFitting where
  connection = 112);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 112);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from DciFitting where
  connection = 112);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN3 from DciFitting where
  connection = 112);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Tee with Flanged Branch ' || DN1 || '/' || DN3 from MixedFitting2 where
  connection = 112);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN2 from MixedFitting2 where
  connection = 112);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from MixedFitting2 where
  connection = 112);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting2 where
  connection = 112);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN3 from MixedFitting where
  connection = 112);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 112);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 112);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 112);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from MixedFitting where
  connection = 112);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting where
  connection = 112);

-- Detail 113
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN3 from DciFitting where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from DciFitting where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from DciFitting where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN3 from DciFitting where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 113);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN3 from MixedFitting2 where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting2 where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting2 where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from MixedFitting2 where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from MixedFitting2 where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting2 where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting2 where
  connection = 113);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN3 from MixedFitting where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 113);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from MixedFitting where
  connection = 113);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 113);
insert into IndividualPosition (select dc_id, 2, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting where
  connection = 113);

-- Detail 114
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN3 from DciFitting where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from DciFitting where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN3 from DciFitting where
  connection = 114);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN3 from MixedFitting2 where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting2 where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting2 where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting2 where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from MixedFitting2 where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting2 where
  connection = 114);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN3 from MixedFitting where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 114);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting where
  connection = 114);

-- Detail 121
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Socket Tee ' || DN1 from DciFitting where
  connection = 121);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 121);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN3 from DciFitting where
  connection = 121);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Socket Tee ' || DN1 from MixedFitting2 where
  connection = 121);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN2 from MixedFitting2 where
  connection = 121);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN3 from MixedFitting2 where
  connection = 121);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Spigot ' || DN3 from MixedFitting2 where
  connection = 121);  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting2 where
  connection = 121);  

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from MixedFitting where
  connection = 121);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 121);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 121);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from MixedFitting where
  connection = 121);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 121);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting where
  connection = 121);

-- Detail 122
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Tee with Flanged Branch ' || DN1 from DciFitting where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Socket Reducer ' || DN1 || '/' || DN3 from DciFitting where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from DciFitting where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from DciFitting where
  connection = 122);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from MixedFitting2 where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from MixedFitting2 where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from MixedFitting2 where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting2 where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from MixedFitting2 where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting2 where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting2 where
  connection = 122);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from MixedFitting where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from MixedFitting where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from MixedFitting where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from MixedFitting where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 122);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting where
  connection = 122);

-- Detail 123
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from DciFitting where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from DciFitting where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from DciFitting where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from DciFitting where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN3 from DciFitting where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from DciFitting where
  connection = 123);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from MixedFitting2 where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting2 where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting2 where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from MixedFitting2 where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting2 where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from MixedFitting2 where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN2 from MixedFitting2 where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting2 where
  connection = 123);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from MixedFitting where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN1 from MixedFitting where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from MixedFitting where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from MixedFitting where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from MixedFitting where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN2 from MixedFitting where
  connection = 123);
insert into IndividualPosition (select dc_id, 1, 'No.', 'PE',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting where
  connection = 123);

-- Detail 124
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 from DciFitting where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN2 from DciFitting where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN1 || '/' || DN3 from DciFitting where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from DciFitting where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from DciFitting where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from DciFitting where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from DciFitting where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN3 from DciFitting where
  connection = 124);

insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN3 from MixedFitting2 where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN1 from MixedFitting2 where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Reducer ' || DN2 || '/' || DN3 from MixedFitting2 where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket ' || DN2 from MixedFitting2 where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from MixedFitting2 where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting2 where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from MixedFitting2 where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting2 where
  connection = 124);
  
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Socket DN2 ' || DN1 from MixedFitting where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'All Flanged Tee ' || DN1 || '/' || DN3 from MixedFitting where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN1 from MixedFitting where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN2 from MixedFitting where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Gate Valve ' || DN3 from MixedFitting where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Pushfit Adapter ' || DN3 from MixedFitting where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Flanged Adapter ' || DN3 from MixedFitting where
  connection = 124);
insert into IndividualPosition (select dc_id, 1, 'No.', 'DCI',
  'Pushfit Reducer ' || DN2 || '/' || DN3 from MixedFitting where
  connection = 124);

