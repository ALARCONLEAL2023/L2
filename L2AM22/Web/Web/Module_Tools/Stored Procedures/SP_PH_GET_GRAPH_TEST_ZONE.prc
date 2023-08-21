CREATE OR REPLACE PROCEDURE SP_PH_GET_GRAPH_TEST_ZONE(
                                          pIdGraph in Number,
                                          pBeginningOfTestZone out Number, 
                                          pEndOfTestZone out Number
                                         )
                                         IS
  vNumRows       Number;
BEGIN

   vNumRows := 0;
   select count(*) into vNumRows from ph_graficas where id_grafica = pIdGraph;
   
   if vNumRows <> 0 then
      select muestra_ini_prueba, muestra_fin_prueba into pBeginningOfTestZone, pEndOfTestZone from ph_graficas where id_grafica = pIdGraph;
   else
      pBeginningOfTestZone := -1;
      pEndOfTestZone := -1;
   end if;

END;
/
