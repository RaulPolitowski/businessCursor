CREATE OR REPLACE FUNCTION public.saldo_anterior_conta(dt_inicial date, id_conta bigint, id_empresa bigint) RETURNS numeric
    LANGUAGE plpgsql
    AS $body$
declare
saldo_anterior numeric(14,2);
begin
select coalesce(sum(valor), 0) into saldo_anterior
from saldoinicialconta
where data < dt_inicial and empresa_id = id_empresa and conta_id = id_conta;
return saldo_anterior;
end;
 $body$;