CREATE OR REPLACE FUNCTION public.update_triggers_enabled() RETURNS text
    LANGUAGE plpgsql
    AS $body$ DECLARE tabelas record;
sql character varying (255);
BEGIN FOR tabelas IN select
	   t.table_schema,
	   t.table_name
	from
	   information_schema.tables t
	inner
	join pg_class p on p.relname = t.table_name
	left
	JOIN pg_index i ON
	(
	   p.oid = i.indrelid
	)
	where
	   table_schema in
	(
	   'public',
	   'notafiscal',
	   'manifesto',
	   'ecf',
	   'cte'
	)
	group by
	   t.table_schema,
	t.table_name
	order by
	   t.table_name LOOP IF EXISTS
	(
	   select
	      event_object_schema as table_schema,
	      event_object_table as table_name,
	      trigger_name
	   from
	      information_schema.triggers
	   where
	      trigger_name = 'trigger_log_' || tabelas.table_name
	   and
	      event_object_schema = tabelas.table_schema
	   and
	      event_object_table = tabelas.table_name
	   group by
	      event_object_schema,
	   event_object_table,
	   trigger_name
	   order by
	      table_schema,
	   table_name
	)
	   THEN sql = 'ALTER TABLE ' || tabelas.table_schema || '.' || tabelas.table_name || ' ENABLE TRIGGER ' ||'trigger_log_' || tabelas.table_name || ';'; raise notice 'SQL %', sql;
execute sql;
else
		RAISE NOTICE 'Não encontrado table e trigger';
END
	IF;
END LOOP;
return 'Processado com sucesso';
END;
$body$;