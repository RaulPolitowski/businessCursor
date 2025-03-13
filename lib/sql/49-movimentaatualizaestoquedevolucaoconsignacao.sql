CREATE OR REPLACE FUNCTION public.movimentaatualizaestoquedevolucaoconsignacao() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$
DECLARE
CONSIGNACAODEVOLUCAO record;
	ITENSDEVOLUCAO record;
	estoqueAnterior numeric(12,4);
BEGIN
SELECT INTO ITENSDEVOLUCAO * from ecf.itemconsignacao ic where ic.id = NEW.item_id;
SELECT INTO estoqueAnterior me.quantatual from movimentoestoque me where me.produto_id = ITENSDEVOLUCAO.produto_id order by me.id desc limit 1;
IF estoqueAnterior is null then
SELECT INTO estoqueAnterior produto.quantidademinima from produto where produto.id = ITENSDEVOLUCAO.produto_id;
IF estoqueAnterior is null then
        	estoqueAnterior = 0;
END IF;
END IF;
SELECT INTO CONSIGNACAODEVOLUCAO * FROM ECF.CONSIGNACAODEVOLUCAO where id = NEW.consignacaodevolucao_id;
INSERT INTO movimentoestoque (datamovimentacao, quantidade, tipomovimento, produto_id, usuario_id, quantanterior, quantatual, justificativa) values
(current_timestamp, (NEW.quantidade + NEW.quantidadeLevada), 'D', ITENSDEVOLUCAO.produto_id, CONSIGNACAODEVOLUCAO.usuario_id, estoqueAnterior, estoqueAnterior + (NEW.quantidade + NEW.quantidadeLevada), 'Devolução de consignação Nº ' || CONSIGNACAODEVOLUCAO.consignacao_id);
UPDATE produto set quantidademinima = (quantidademinima + (NEW.quantidade + NEW.quantidadeLevada)) where id = ITENSDEVOLUCAO.produto_id;
RETURN NEW;
END;
$body$;