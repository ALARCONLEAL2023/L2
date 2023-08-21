CREATE OR REPLACE PROCEDURE SP_PH_GET_IDENT_COUNT (
                                                  pNumIdentifications out number
) IS

BEGIN

  pNumIdentifications := 0;
  
  begin
     select count(*) into pNumIdentifications
     from ph_identificaciones
     where confirmado = 0 and copiado_a_prod = 0
     order by ordenamiento desc, fecha asc;
  exception
     when others then
        pNumIdentifications := 0;
  end;

END;
/
