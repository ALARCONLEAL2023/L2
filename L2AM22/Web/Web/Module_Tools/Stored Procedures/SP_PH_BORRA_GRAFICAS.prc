CREATE OR REPLACE PROCEDURE SP_PH_BORRA_GRAFICAS(pIdGrafica in Number, pIdUsuario in Varchar2, pResultado out Number) IS

vNumRegs Number;
vIdTubo Number;
BEGIN

    select count(*) into vNumRegs from PH_GRAFICAS where id_grafica = pIdGrafica and borrada = 0 and id_identificacion is null;
    if vNumRegs > 0 then

       select id_tubo into vIdTubo from PH_GRAFICAS where id_grafica = pIdGrafica and borrada = 0 and id_identificacion is null;
       update PH_GRAFICAS set borrada = 1, id_user = pIdUsuario where id_tubo = vIdTubo and borrada = 0 and id_identificacion is null;
       pResultado := 1;

    else
       pResultado := 0;
    end if;


END SP_PH_BORRA_GRAFICAS;
/
