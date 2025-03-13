CREATE OR REPLACE FUNCTION public.quantidade_estoque_reservado_ordem_servico(id_produto bigint) RETURNS numeric
    LANGUAGE plpgsql
    AS $body$
						 declare
estoque_reservado numeric(15,4);
begin
SELECT coalesce(sum(itemordemservico.quantidade), 0) INTO estoque_reservado
FROM itemordemservico
         JOIN ordemservico on itemordemservico.ordemservico_id = ordemservico.id
     -- Somente considerar o item ainda nao faturado e as ordem não canceladas
WHERE ordemservico.status != 'CANCELADO' and itemordemservico.faturaitem_id is null and itemordemservico.produto_id = id_produto;
return estoque_reservado;
end;
	$body$;