CREATE OR REPLACE FUNCTION public.movimentacaoestoqueaposemissaocupomfiscal() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$
					DECLARE
lista record;
					estoqueAnterior NUMERIC(15,4);
BEGIN
					IF(NEW.contabil is true) then
						return NEW;
end IF;
					IF(NEW.codigoretornosat = '06000' and (OLD.codigoretornosat is null or OLD.codigoretornosat <> '06000')) THEN
						FOR lista IN
select item.*
from ecf.cupomfiscal cupom
         inner join ecf.itemcupomfiscal item on cupom.id = item.cupomfiscal_id
where cupom = NEW
    LOOP
							IF lista.estoquegerado is false THEN
SELECT INTO estoqueAnterior me.quantatual from movimentoestoque me where me.produto_id = lista.produto_id order by me.id desc limit 1;
IF estoqueAnterior is null then
SELECT INTO estoqueAnterior produto.quantidademinima from produto where produto.id = lista.produto_id;
IF estoqueAnterior is null then
										estoqueAnterior = 0;
END IF;
END IF;
INSERT INTO public.MOVIMENTOESTOQUE(datamovimentacao, quantidade, tipomovimento, produto_id, usuario_id, quantanterior, quantatual, justificativa, origemmovimentacao) values (current_timestamp, lista.quantidade, 'S', lista.produto_id, NEW.usuariocadastro_id,  estoqueAnterior, estoqueAnterior - lista.quantidade, 'Saída de produto por CF-e SAT Nº ' || NEW.numero, 'SAT');
UPDATE produto set quantidademinima = (quantidademinima - lista.quantidade) where id = lista.produto_id;
UPDATE ecf.itemcupomfiscal set estoquegerado = TRUE where id = lista.id;
END IF;
END LOOP;
END IF;
RETURN NEW;
END
					$body$;