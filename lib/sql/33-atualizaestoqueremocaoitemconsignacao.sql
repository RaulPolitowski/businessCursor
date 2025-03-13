CREATE OR REPLACE FUNCTION public.atualizaestoqueremocaoitemconsignacao() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$
DECLARE
consignacao record;
estoqueAnterior numeric(12,4);
quantidadeDif numeric(12,4);
BEGIN
SELECT INTO estoqueAnterior me.quantatual from movimentoestoque me where me.produto_id = OLD.produto_id order by me.id desc limit 1;

IF estoqueAnterior is null then
SELECT INTO estoqueAnterior produto.quantidademinima from produto where produto.id = OLD.produto_id;
IF estoqueAnterior is null then
			estoqueAnterior = 0;
END IF;
END IF;

SELECT INTO CONSIGNACAO * FROM ECF.CONSIGNACAO where id = OLD.consignacao_id;

INSERT INTO movimentoestoque (datamovimentacao, quantidade, tipomovimento, produto_id, usuario_id, quantanterior, quantatual, justificativa) values	(current_timestamp, OLD.quantidade, 'D', OLD.produto_id, CONSIGNACAO.usuarioalteracao_id, estoqueAnterior, estoqueAnterior + OLD.quantidade, 'Devolução de consignação Nº ' || CONSIGNACAO.id );

UPDATE produto set quantidademinima = (quantidademinima + OLD.quantidade) where id = OLD.produto_id;
RETURN NEW;
END;
$body$;
