CREATE OR REPLACE FUNCTION public.atualizarreservaproduto() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$
DECLARE
BEGIN
								IF(TG_OP = 'DELETE') THEN
UPDATE produto SET quantidadereservada = public.quantidade_estoque_reservado(OLD.produto_id) where id = OLD.produto_id;
RETURN OLD;
ELSE
UPDATE produto SET quantidadereservada = public.quantidade_estoque_reservado(NEW.produto_id) where id = NEW.produto_id;
RETURN NEW;
END IF;
END
						$body$;