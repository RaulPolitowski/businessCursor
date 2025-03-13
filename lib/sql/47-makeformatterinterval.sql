CREATE OR REPLACE FUNCTION public.makeformatterinterval(intervalo interval) RETURNS text
    LANGUAGE plpgsql
    AS $body$ DECLARE
dataFormatada text;
							dados record;
BEGIN

							dataFormatada = '';

SELECT
    extract(year from intervalo) AS anos,
    extract(month from intervalo) AS meses,
    extract(day from intervalo) AS dias,
    extract(hour from intervalo) AS horas,
    extract(minute from intervalo) AS minutos,
    extract(second from intervalo)::numeric(14,1) AS segundos
INTO dados;
--raise notice 'teste (%)', dados.dias;

IF dados.anos != 0 THEN
								IF dados.anos = 1 THEN
									dataFormatada = dataFormatada || dados.anos || ' ano ';
ELSE
									dataFormatada = dataFormatada || dados.anos || ' anos ';
END IF;
END IF;

							IF dados.meses != 0 THEN
								IF dados.meses = 1 THEN
									dataFormatada = dataFormatada || dados.meses || ' mês ';
ELSE
									dataFormatada = dataFormatada || dados.meses || ' meses ';
END IF;
END IF;

							IF dados.dias != 0 THEN
								IF dados.dias = 1 THEN
									dataFormatada = dataFormatada || dados.dias || ' dia ';
ELSE
									dataFormatada = dataFormatada || dados.dias || ' dias ';
END IF;
END IF;

							IF dados.horas != 0 THEN
								IF dados.horas = 1 THEN
									dataFormatada = dataFormatada || dados.horas || ' hora ';
ELSE
									dataFormatada = dataFormatada || dados.horas || ' horas ';
END IF;
END IF;

							IF dados.minutos != 0 THEN
								IF dados.minutos = 1 THEN
									dataFormatada = dataFormatada || dados.minutos || ' minuto ';
ELSE
									dataFormatada = dataFormatada || dados.minutos || ' minutos ';
END IF;
END IF;

							IF dados.segundos != 0 THEN
								IF dados.segundos = 1 THEN
									dataFormatada = dataFormatada || dados.segundos || ' segundo ';
ELSE
									dataFormatada = dataFormatada || dados.segundos || ' segundos ';
END IF;
END IF;

return dataFormatada;
END;
						$body$;