CREATE OR REPLACE FUNCTION public.valor_historico_compra(dt_registro date, id_produto bigint, id_empresa bigint, qt_venda numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $body$
					 declare
valor_historico numeric(14,2);
begin

select (h.valorunitario * qt_venda) into valor_historico
from historicoprecocompraproduto h
where h.data <= dt_registro
  and h.produto_id = id_produto
  and h.empresa_id = id_empresa
order by h.data desc limit 1;

return valor_historico;
end;
					$body$;