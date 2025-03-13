CREATE OR REPLACE FUNCTION public.saldo_anterior_movimentacao(dt_inicial date, id_conta bigint, id_empresa bigint) RETURNS numeric
    LANGUAGE plpgsql
    AS $body$
 declare
saldo numeric(14,2);
begin
select coalesce(sum(case tipomovimentacao when 'C' then valor
                                          when 'D' then (valor*-1) else 0 end), 0) + saldo_anterior_conta(dt_inicial, id_conta, id_empresa) into saldo
from movimentacaobancaria
where empresa_id = id_empresa and datamovimentacao < dt_inicial and conta_id = id_conta;
return saldo;
end;
 $body$;