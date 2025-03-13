CREATE OR REPLACE FUNCTION public.atualizaestoqueedicaoconsignacao() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$
DECLARE
consignacao record;
estoqueAnterior numeric(12,4);
quantidadeDif numeric(12,4);
BEGIN
SELECT INTO estoqueAnterior me.quantatual from movimentoestoque me where me.produto_id = NEW.produto_id order by me.id desc limit 1;
IF estoqueAnterior is null then
SELECT INTO estoqueAnterior produto.quantidademinima from produto where produto.id = new.produto_id;
IF estoqueAnterior is null then
			estoqueAnterior = 0;
END IF;
END IF;

SELECT INTO CONSIGNACAO * FROM ECF.CONSIGNACAO where id = NEW.consignacao_id;

quantidadeDif = (OLD.quantidade - NEW.quantidade);

	IF quantidadeDif > 0 then

		INSERT INTO movimentoestoque (datamovimentacao, quantidade, tipomovimento, produto_id, usuario_id, quantanterior, quantatual, justificativa) values (current_timestamp, quantidadeDif, 'D', NEW.produto_id, CONSIGNACAO.usuarioalteracao_id, estoqueAnterior, estoqueAnterior + quantidadeDif, 'Devolução de consignação Nº ' || CONSIGNACAO.id );

UPDATE produto set quantidademinima = (quantidademinima + quantidadeDif) where id = NEW.produto_id;
END IF;

	IF quantidadeDif < 0 then
		quantidadeDif = quantidadeDif * -1;

INSERT INTO movimentoestoque (datamovimentacao, quantidade, tipomovimento, produto_id, usuario_id, quantanterior, quantatual, justificativa) values (current_timestamp, quantidadeDif, 'C', NEW.produto_id, CONSIGNACAO.usuarioalteracao_id, estoqueAnterior, estoqueAnterior - quantidadeDif, 'Saída de produto em consignação nº ' || CONSIGNACAO.id );

UPDATE produto set quantidademinima = (quantidademinima - quantidadeDif) where id = NEW.produto_id;
END IF;

RETURN NEW;
END;
$body$;