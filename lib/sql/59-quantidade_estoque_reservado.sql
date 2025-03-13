CREATE OR REPLACE FUNCTION public.quantidade_estoque_reservado(id_produto bigint) RETURNS numeric
    LANGUAGE plpgsql
    AS $body$
declare
estoque_reservado_pedido numeric(15,4);
						 estoque_reservado_ordemservico numeric(15,4);
begin
							-- quantidade total do estoque reservado para o pedido
							estoque_reservado_pedido = quantidade_estoque_reservado_pedido(id_produto);
							-- quantidade total do estoque reservado para a ordem de servico
							estoque_reservado_ordemservico = quantidade_estoque_reservado_ordem_servico(id_produto);
							-- quantidade total reservado (pedido + ordem de servico)
return estoque_reservado_pedido + estoque_reservado_ordemservico;
end;
$body$;