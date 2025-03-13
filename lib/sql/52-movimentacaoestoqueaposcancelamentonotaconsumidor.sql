CREATE OR REPLACE FUNCTION public.movimentacaoestoqueaposcancelamentonotaconsumidor() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$
					DECLARE
lista record;
						estoqueAnterior NUMERIC(15,4);
BEGIN
						IF(NEW.contabil is true) then
							return NEW;
end IF;
						IF(NEW.codigoretorno LIKE '101%' and OLD.codigoretorno <> '101') THEN
								IF (NEW.tipoFaturamento = '1') THEN
									FOR lista IN
select infc.*
from notafiscal.notafiscalconsumidor nfc
         inner join notafiscal.itemnotafiscalconsumidor infc on nfc.id = infc.notafiscalconsumidor_id
where nfc = NEW
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
values (current_timestamp, lista.quantidade, 'E', lista.produto_id, NEW.usuariocadastro_id, estoqueAnterior, estoqueAnterior + lista.quantidade, 'Cancelamento de NFC-e Nº ' || NEW.numero, 'NFC');
END IF;
END LOOP;
END IF;
END IF;
RETURN NEW;
END;
					$body$;