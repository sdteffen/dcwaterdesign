-- 
create or replace function DropDuplicates(varchar,varchar)
	returns text
	as 
'
declare
	table_name alias for $1;
	column_name alias for $2;
begin
  execute ''delete from '' || quote_ident(table_name) || '' where  oid  > '' ||
    ''(select min(oid) from '' || quote_ident(table_name) || '' as t where
    t.'' || quote_ident(column_name) || '' = '' || quote_ident(table_name) || 
    ''.'' || quote_ident(column_name) || '')'';
END;
' LANGUAGE 'plpgsql' WITH (isstrict);
