CREATE OR REPLACE FUNCTION public.fu_extenso_real(num numeric) RETURNS text
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $body$
begin
return fu_extenso(num,'Real','Reais') ;
end ;
$body$