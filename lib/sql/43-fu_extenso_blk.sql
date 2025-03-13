CREATE OR REPLACE FUNCTION public.fu_extenso_blk(num character) RETURNS text
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $body$
declare
w_cen integer ;
w_dez integer ;
w_dez2 integer ;
w_uni integer ;
w_tcen text ;
w_tdez text ;
w_tuni text ;
w_ext text ;
m_cen text[] := array['','Cento','Duzentos','Trezentos','Quatrocentos','Quinhentos','Seiscentos','Setecentos','Oitocentos','Novecentos'];
m_dez text[] := array['','Dez','Vinte','Trinta','Quarenta','Cinquenta','Sessenta','Setenta', 'Oitenta','Noventa'] ;
m_uni text[] := array['','Um','Dois','Três','Quatro','Cinco','Seis','Sete','Oito','Nove','Dez','Onze','Doze','Treze','Quatorze','Quinze','Dezesseis','Dezessete','Dezoito','Dezenove'] ;
begin
  w_cen := cast(substr(num,1,1) as integer) ;
   w_dez := cast(substr(num,2,1) as integer) ;
   w_dez2 := cast(substr(num,2,2) as integer) ;
   w_uni := cast(substr(num,3,1) as integer) ;
   if w_cen = 1 and w_dez2 = 0 then
      w_tcen := 'Cem' ;
      w_tdez := '' ;
      w_tuni := '' ;
else
      if w_dez2 < 20 then
         w_tcen := m_cen[w_cen + 1] ;
         w_tdez := m_uni[w_dez2 + 1] ;
         w_tuni := '' ;
else
         w_tcen := m_cen[w_cen + 1] ;
         w_tdez := m_dez[w_dez + 1] ;
         w_tuni := m_uni[w_uni + 1] ;
end if ;
end if ;
   w_ext := w_tcen ;
   if w_tdez <> '' then
      if w_ext = '' then
         w_ext := w_tdez ;
else
         w_ext := w_ext || ' e ' || w_tdez ;
end if ;
end if ;
   if w_tuni <> '' then
      if w_ext = '' then
         w_ext := w_tuni ;
else
         w_ext := w_ext || ' e ' || w_tuni ;
end if ;
end if ;
return w_ext ;
end ;
$body$;