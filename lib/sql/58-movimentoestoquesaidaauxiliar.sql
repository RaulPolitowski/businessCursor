CREATE OR REPLACE FUNCTION public.movimentoestoquesaidaauxiliar() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$ DECLARE auxiliarvenda record; estoqueAnterior numeric(15, 4); BEGIN
SELECT INTO auxiliarvenda * from ecf.auxiliarvenda
where
    id = NEW.auxiliarvenda_id;
SELECT INTO estoqueAnterior me.quantatual from movimentoestoque me
where
    me.produto_id = NEW.produto_id
order by
    me.id desc
    limit 1;
IF estoqueAnterior is null then
SELECT INTO estoqueAnterior produto.quantidademinima from produto
where
    produto.id = new.produto_id;IF estoqueAnterior is null then estoqueAnterior = 0;END IF;END IF;
INSERT INTO movimentoestoque (datamovimentacao, quantidade, tipomovimento, produto_id, usuario_id, quantanterior, quantatual, justificativa, origemmovimentacao)
values (current_timestamp, NEW.quantidade, 'S', NEW.produto_id, auxiliarvenda.usuarioalteracao_id, estoqueAnterior, estoqueAnterior - NEW.quantidade, 'Saída de Produto por Venda Auxiliar Nº ' || auxiliarvenda.ID, 'AUXILIAR_VENDA');
UPDATE produto set quantidademinima = (quantidademinima - NEW.quantidade)
where
        id = NEW.produto_id;RETURN NEW;END;
					 $body$;