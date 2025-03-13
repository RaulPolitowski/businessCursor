CREATE OR REPLACE FUNCTION public.movimentacaoestoqueaposcancelamentocupomfiscal() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$
					DECLARE
lista record;
						estoqueAnterior NUMERIC(15,4);
BEGIN
						IF(NEW.contabil is true) then
							return NEW;
end IF;
						IF(NEW.codigoretornosat LIKE '07000%' and OLD.codigoretornosat <> '07000') THEN
							FOR lista IN
select item.*
from ecf.cupomfiscal cupom
         inner join ecf.itemcupomfiscal item on cupom.id = item.cupomfiscal_id
where cupom = NEW
    LOOP
								IF lista.estoquegerado is true THEN
SELECT INTO estoqueAnterior me.quantatual from movimentoestoque me where me.produto_id = lista.produto_id order by me.id desc limit 1;
IF estoqueAnterior is null then
SELECT INTO estoqueAnterior produto.quantidademinima from produto where produto.id = lista.produto_id;
IF estoqueAnterior is null then
											estoqueAnterior = 0;
END IF;
END IF;
INSERT INTO public.MOVIMENTOESTOQUE(datamovimentacao, quantidade, tipomovimento, produto_id, usuario_id, quantanterior, quantatual, justificativa, origemmovimentacao)
values (current_timestamp, lista.quantidade, 'E', lista.produto_id, NEW.usuariocadastro_id, estoqueAnterior, estoqueAnterior + lista.quantidade, 'Cancelamento de CF-e SAT Nº ' || NEW.numero, 'SAT');
END IF;
END LOOP;
END IF;
RETURN NEW;
END;
					$body$;