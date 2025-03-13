CREATE OR REPLACE FUNCTION public.atualizarusuariocaixaaberto() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$ BEGIN
					INSERT INTO usuariocaixa (empresa_id, usuario_id, caixa_id) VALUES(NEW.empresa_id, NEW.usuario_id, NEW.id);
RETURN NEW; END $body$;