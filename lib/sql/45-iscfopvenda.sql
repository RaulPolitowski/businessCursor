CREATE OR REPLACE FUNCTION public.iscfopvenda(cfop_id bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $body$
begin
							PERFORM cfop.id, cfop.codigo
							FROM cfop
							WHERE cfop.id = cfop_id AND codigo NOT IN ('5904', '6904');

							IF FOUND THEN
								RETURN TRUE;
ELSE
					      		RETURN FALSE;
END IF;
end;
					$body$;