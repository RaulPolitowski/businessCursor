CREATE OR REPLACE FUNCTION public.fu_extenso(num numeric, moeda text, moedas text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $body$
declare
w_int char(21) ;
		x integer ;
		v integer ;
		w_ret text ;
		w_ext text ;
		w_apoio text ;
 	m_cen text[] := array['Quatrilhão','Quatrilhões','Trilhão','Trilhões','Bilhão','Bilhões','Milhão','Milhões','Mil','Mil'] ;
begin
		  w_ret := '' ;
		  w_int := to_char(num * 100 , 'fm000000000000000000 00') ;
for x in 1..5 loop
		      v := cast(substr(w_int,(x-1)*3 + 1,3) as integer) ;
		      if v > 0 then
		         if v > 1 then
		            w_ext := m_cen[(x-1)*2+2] ;
else
		            w_ext := m_cen[(x-1)*2+1] ;
end if ;
		         w_ret := w_ret || fu_extenso_blk(substr(w_int,(x-1)*3 + 1,3)) || ' ' || w_ext ||', ' ;
end if ;
end loop ;
		  v := cast(substr(w_int,16,3) as integer) ;
		  if v > 0 then
		     if v > 1 then
		        w_ext := moedas ;
else
		        if w_ret = '' then
		           w_ext := moeda ;
else
		           w_ext := moedas ;
end if ;
end if ;
		     w_apoio := fu_extenso_blk(substr(w_int,16,3)) || ' ' || w_ext ;
		     if w_ret = '' then
		        w_ret := w_apoio ;
else
		        if v > 100 then
		           if w_ret = '' then
		              w_ret := w_apoio ;
else
		              w_ret := w_ret || w_apoio ;
end if ;
else
		           w_ret := btrim(w_ret,', ') || ' e ' || w_apoio ;
end if ;
end if ;
else
		     if w_ret <> '' then
		        if substr(w_int,13,6) = '000000' then
		           w_ret := btrim(w_ret,', ') || ' de ' || moedas ;
else
		           w_ret := btrim(w_ret,', ') || ' ' || moedas ;
end if ;
end if ;
end if ;
		  v := cast(substr(w_int,20,2) as integer) ;
		  if v > 0 then
		     if v > 1 then
		        w_ext := 'Centavos' ;
else
		        w_ext := 'Centavo' ;
end if ;
		     w_apoio := fu_extenso_blk('0'||substr(w_int,20,2)) || ' ' || w_ext ;
		     if w_ret = '' then
		        w_ret := w_apoio ;
else
		        w_ret := w_ret || ' e ' || w_apoio ;
end if ;
end if ;
return w_ret ;
end ;
		 $body$;