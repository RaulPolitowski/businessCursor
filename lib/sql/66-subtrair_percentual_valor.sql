CREATE OR REPLACE FUNCTION public.subtrair_percentual_valor(valor numeric, percentual numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $body$
begin
							-- CALCULA O VALOR DO PERCENTUAL RELATIVO AO VALOR INFORMADO E SOMA AO VALOR INFORMADO. RETORNO COM 2 DECIMAIS
							--EX: 100,00 (valor) >> 10,00% (percentual) = 110,00 (retorno)
return valor - calcular_valor_percentual(valor, percentual);
end;
						$body$;