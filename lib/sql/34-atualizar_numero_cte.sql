CREATE OR REPLACE FUNCTION public.atualizar_numero_cte() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$
DECLARE
ultimo_numero integer;
BEGIN
SELECT INTO ultimo_numero max(cte.numero)
FROM cte.cte cte
WHERE cte.serie = NEW.serie
  AND cte.empresa_id = NEW.empresa_id
  AND cte.ambiente = NEW.ambiente;
if(ultimo_numero >= NEW.numero) then
							NEW.numero = ultimo_numero + 1;
end if;

RETURN NEW;
END
$body$;