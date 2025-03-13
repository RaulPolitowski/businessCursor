CREATE OR REPLACE FUNCTION public.atualizarreservaprodutoordemservico() RETURNS trigger
    LANGUAGE plpgsql
    AS $body$
DECLARE
lista record;
BEGIN
FOR lista IN
select item.*
from public.ordemservico ordemservico
         inner join public.itemordemservico item on ordemservico.id = item.ordemservico_id
where ordemservico = NEW
    LOOP
UPDATE produto SET quantidadereservada = public.quantidade_estoque_reservado(lista.produto_id) where id = lista.produto_id;
END LOOP;
RETURN NEW;
END
$body$;