CREATE OR REPLACE FUNCTION public.atualizarreservaprodutopedido() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$
DECLARE
lista record;
BEGIN
FOR lista IN
select item.*
from public.pedido pedido
         inner join public.itempedido item on pedido.id = item.pedido_id
where pedido = NEW
    LOOP
UPDATE produto SET quantidadereservada = public.quantidade_estoque_reservado(lista.produto_id) where id = lista.produto_id;
END LOOP;
RETURN NEW;
END
						$body$;