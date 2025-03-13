CREATE OR REPLACE FUNCTION public.reprocessaestoqueitem(item integer) RETURNS text
    LANGUAGE plpgsql
    AS $body$
DECLARE
movimentacoes record;
  primeiroRegistro BOOLEAN;
  estoqueAtual NUMERIC(12,4);
  anterior NUMERIC(12,4);
  atual NUMERIC(12,4);
BEGIN
select into estoqueAtual produto.quantidademinima from produto where produto.id = item;
primeiroRegistro = true;
for movimentacoes in select * from movimentoestoque p where p.produto_id = item order by p.id desc
    LOOP
     	if(movimentacoes.tipomovimento = 'E' or movimentacoes.tipomovimento = 'D' or movimentacoes.tipomovimento = 'EM') then
          if(primeiroregistro) then
              atual = estoqueatual;
anterior = atual - movimentacoes.quantidade;
              primeiroregistro = false;
ELSE
              anterior = atual - movimentacoes.quantidade;
end if;
else
          if(primeiroregistro) then
              atual = estoqueatual;
              anterior = atual + movimentacoes.quantidade;
              primeiroregistro = false;
ELSE
              anterior = atual + movimentacoes.quantidade;
end if;
end if;

update movimentoestoque
set quantanterior = anterior, quantatual = atual
where id = movimentacoes.id;
atual = anterior;
end LOOP;
return 'Reprocessado com sucesso';
END;
$body$;