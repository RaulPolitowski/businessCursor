CREATE OR REPLACE FUNCTION public.reprocessaestoque() RETURNS void
    LANGUAGE plpgsql
    AS $body$
DECLARE
itens record;
  codigo integer;
  retorno text;
BEGIN
for itens in select * from produto PERFORM LOOP
    	codigo = itens.id;
select reprocessaEstoqueItem(codigo) into retorno;
end LOOP;
END;
$body$;
