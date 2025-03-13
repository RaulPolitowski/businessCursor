CREATE OR REPLACE FUNCTION public.atualizarusuariocaixafechado() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$ BEGIN
					IF NEW.aberto is false THEN
DELETE FROM usuariocaixa WHERE caixa_id = NEW.id AND empresa_id = NEW.empresa_id;
END IF; RETURN NEW; END $body$;