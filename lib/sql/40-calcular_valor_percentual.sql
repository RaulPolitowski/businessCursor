CREATE OR REPLACE FUNCTION public.calcular_valor_percentual(valor numeric, percentual numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $body$
begin
							-- CALCULA O VALOR DO PERCENTUAL RELATIVO AO VALOR INFORMADO. RETORNO COM 2 DECIMAIS
							--EX: 100,00 (valor) >> 10,00% (percentual) = 10,00 (retorno)
return ROUND((valor/100)*percentual, 2);
end;
						$body$;