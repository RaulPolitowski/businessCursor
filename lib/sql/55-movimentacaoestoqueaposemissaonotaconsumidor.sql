CREATE OR REPLACE FUNCTION public.movimentacaoestoqueaposemissaonotaconsumidor() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$
					DECLARE
lista record;
					estoqueAnterior NUMERIC(15,4);
BEGIN
					IF(NEW.contabil is true) then
						return NEW;
end IF;
					IF((NEW.codigoretorno = '100' AND (OLD.tipoEmissao <> '9' AND (OLD.codigoretorno is null or OLD.codigoretorno <> '100'))) OR NEW.tipoEmissao='9') THEN
							IF (NEW.tipoFaturamento = '1') THEN
								FOR lista IN
select infc.*
from notafiscal.notafiscalconsumidor nfc
         inner join notafiscal.itemnotafiscalconsumidor infc on nfc.id = infc.notafiscalconsumidor_id
where nfc = NEW
    LOOP
									IF lista.estoquegerado is false THEN
SELECT INTO estoqueAnterior me.quantatual from movimentoestoque me where me.produto_id = lista.produto_id order by me.id desc limit 1;
IF estoqueAnterior is null then
SELECT INTO estoqueAnterior produto.quantidademinima from produto where produto.id = lista.produto_id;
IF estoqueAnterior is null then
					        						estoqueAnterior = 0;
END IF;
END IF;
INSERT INTO public.MOVIMENTOESTOQUE(datamovimentacao, quantidade, tipomovimento, produto_id, usuario_id, quantanterior, quantatual, justificativa, origemmovimentacao) values (current_timestamp, lista.quantidade, 'S', lista.produto_id, NEW.usuariocadastro_id,  estoqueAnterior, estoqueAnterior - lista.quantidade, 'Saída de produto por NFC-e Nº ' || NEW.numero, 'NFC');
UPDATE produto set quantidademinima = (quantidademinima - lista.quantidade) where id = lista.produto_id;
UPDATE notafiscal.itemnotafiscalconsumidor set estoquegerado = TRUE where id = lista.id;
END IF;
END LOOP;
END IF;
END IF;
RETURN NEW;
END
					$body$;