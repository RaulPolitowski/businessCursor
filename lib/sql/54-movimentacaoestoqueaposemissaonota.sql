CREATE OR REPLACE FUNCTION public.movimentacaoestoqueaposemissaonota() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$
DECLARE
lista record;
					  estoqueAnterior NUMERIC(15,4);
BEGIN
					IF(NEW.contabil is true) then
						return NEW;
end IF;
					IF(NEW.codigoretorno = '100' and (OLD.codigoretorno is null or OLD.codigoretorno <> '100')) THEN
							IF (NEW.tipoFaturamento = '1') THEN
								FOR lista IN
select inf.*
from notafiscal.notafiscal nf
         inner join notafiscal.itemnotafiscal inf on	nf.numero = inf.numero
    and nf.serie = inf.serie
    and nf.tipofaturamento = inf.tipoFaturamento
    and nf.empresaid = inf.empresaId
    and nf.ambiente = inf.ambiente
where nf.numero = NEW.numero
  and nf.serie = NEW.serie
  and nf.tipofaturamento = NEW.tipoFaturamento
  and nf.empresaid = NEW.empresaid
  and nf.ambiente = NEW.ambiente
    LOOP
								IF lista.estoquegerado is false THEN
SELECT INTO estoqueAnterior me.quantatual from movimentoestoque me where me.produto_id = lista.produto_id order by me.id desc limit 1;
IF estoqueAnterior is null then
SELECT INTO estoqueAnterior produto.quantidademinima from produto where produto.id = lista.produto_id;
IF estoqueAnterior is null then
								        						estoqueAnterior = 0;
END IF;
END IF;
INSERT INTO public.MOVIMENTOESTOQUE(datamovimentacao, quantidade, tipomovimento, produto_id, usuario_id, quantanterior, quantatual, justificativa, origemmovimentacao) values
(current_timestamp, lista.quantidade, 'S', lista.produto_id, NEW.usuariocadastro_id, estoqueAnterior, estoqueAnterior - lista.quantidade, 'Saída de Produto por NF-e Nº ' || NEW.numero, 'NFE');
UPDATE produto set quantidademinima = (quantidademinima - lista.quantidade) where id = lista.produto_id;
UPDATE notafiscal.itemnotafiscal set estoquegerado = TRUE where id = lista.id;
END IF;
END LOOP;
END IF;
										IF (NEW.tipoFaturamento = '0') THEN
											FOR lista IN
select inf.*
from notafiscal.notafiscal nf
         inner join notafiscal.itemnotafiscal inf on nf.numero = inf.numero
    and nf.serie = inf.serie
    and nf.tipofaturamento = inf.tipoFaturamento
    and nf.empresaid = inf.empresaId
    and nf.ambiente = inf.ambiente
where nf.numero = NEW.numero
  and nf.serie = NEW.serie
  and nf.tipofaturamento = NEW.tipoFaturamento
  and nf.empresaid = NEW.empresaid
  and nf.ambiente = NEW.ambiente
    LOOP
												IF lista.estoquegerado is false THEN
SELECT INTO estoqueAnterior me.quantatual from movimentoestoque me where me.produto_id = lista.produto_id order by me.id desc limit 1;
IF estoqueAnterior is null then
SELECT INTO estoqueAnterior produto.quantidademinima from produto where produto.id = lista.produto_id;
IF estoqueAnterior is null then
								        						estoqueAnterior = 0;
END IF;
END IF;
INSERT INTO public.MOVIMENTOESTOQUE(datamovimentacao, quantidade, tipomovimento, produto_id, usuario_id, quantanterior, quantatual, justificativa, origemmovimentacao)
values (current_timestamp, lista.quantidade, 'E', lista.produto_id, NEW.usuariocadastro_id, estoqueAnterior, estoqueAnterior + lista.quantidade, 'Entrada de produto por NF-e Nº ' || NEW.numero, 'NFE');
UPDATE notafiscal.itemnotafiscal set estoquegerado = TRUE where id = lista.id;
END IF;
END LOOP;
END IF;
END IF;
RETURN NEW;
END;
								$body$;