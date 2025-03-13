CREATE OR REPLACE FUNCTION public.quantidade_estoque_reservado_pedido(id_produto bigint) RETURNS numeric
    LANGUAGE plpgsql
    AS $body$
declare
estoque_reservado numeric(15,4);
begin
SELECT coalesce(sum(itempedido.quantidade), 0) INTO estoque_reservado
FROM itempedido
         JOIN pedido on itempedido.pedido_id = pedido.id
     -- Somente considerar pedidos em abertos
WHERE pedido.statuspedido <> 'CANCELADO' AND pedido.statuspedido <> 'FECHADO' AND pedido.statuspedido <> 'CONCLUIDO' AND itempedido.faturaitem_id is null  AND itempedido.produto_id = id_produto;
return estoque_reservado;
end;
					$body$;