CREATE OR REPLACE FUNCTION public.movimentaatualizaestoquecancelamentoconsignacao() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$
DECLARE
lista record;
estoqueAnterior numeric(12,4);
BEGIN
	IF NEW.cancelada = true THEN
		FOR lista IN SELECT * from ecf.itemconsignacao ic where ic.consignacao_id = NEW.id
    LOOP
SELECT INTO estoqueAnterior me.quantatual from movimentoestoque me where me.produto_id = lista.produto_id order by me.id desc limit 1;
IF estoqueAnterior is null then
SELECT INTO estoqueAnterior produto.quantidademinima from produto where produto.id = lista.produto_id;
IF estoqueAnterior is null then
	            	estoqueAnterior = 0;
END IF;
END IF;
INSERT INTO movimentoestoque (datamovimentacao, quantidade, tipomovimento, produto_id, usuario_id, quantanterior, quantatual, justificativa) values
(current_timestamp, lista.quantidade, 'E', lista.produto_id, NEW.usuario_id, estoqueAnterior, estoqueAnterior + lista.quantidade, 'Cancelamento de consignação Nº ' || NEW.id);
END LOOP;
END IF;
RETURN NEW;
END;
$body$;