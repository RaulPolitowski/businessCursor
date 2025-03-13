CREATE OR REPLACE FUNCTION public.movimentoestoquedevolucaoauxiliar() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$ DECLARE lista record; estoqueAnterior NUMERIC(15, 4);BEGIN IF NEW.CANCELADA = true AND OLD.CANCELADA = false then FOR lista IN
select * from ecf.produtoauxiliarvenda
where
        auxiliarvenda_id = NEW.id LOOP
SELECT INTO estoqueAnterior me.quantatual from movimentoestoque me
where
    me.produto_id = lista.produto_id
order by
    me.id desc
    limit 1;
IF estoqueAnterior is null then
SELECT INTO estoqueAnterior produto.quantidademinima from produto
where
    produto.id = new.produto_id;IF estoqueAnterior is null then estoqueAnterior = 0;END IF;END IF;
INSERT INTO movimentoestoque (datamovimentacao, quantidade, tipomovimento, produto_id, usuario_id, quantanterior, quantatual, justificativa, origemmovimentacao)
values (current_timestamp, lista.quantidade, 'D', lista.produto_id, NEW.usuarioalteracao_id, estoqueAnterior, estoqueAnterior + lista.quantidade, 'Cancelamento de Venda Auxiliar Nº ' || NEW.id, 'AUXILIAR_VENDA');
UPDATE produto set quantidademinima = (quantidademinima + lista.quantidade)
where
        produto.id = lista.produto_id;END LOOP;end if;RETURN NEW;END;
						 $body$;