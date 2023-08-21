CREATE OR REPLACE PROCEDURE SP_PH_GET_GRAPH_DATA(
                                          pOP in Number,
                                          pProgressive in Number,
                                          pNumberOfTest in Number,

                                          pGraph out Blob, 
                                          pHeat out Number, 
                                          pStatus out Varchar2, 
                                          pSamplingTime out Number, 
                                          pMaxPressure out Number, 
                                          pPurgeTime out Number, 
                                          pDesiredPressureTime out Number, 
                                          pTestTime out Number, 
                                          pZeroPressureTime out Number, 
                                          pPressure out Number, 
                                          pTracking out Number,
                                          pBeginningOfTestZone out Number,
                                          pEndOfTestZone out Number
                                         )
                                         IS
  vIdGraph Number; 
  vNumRegs Number;
BEGIN
  
  vNumRegs := 0;
  select count(*) into vNumRegs from produccion_ph
  where orden = pOP and progresivo = pProgressive and nfalla = pNumberOfTest;
  
  if vNumRegs > 0 then
      select Colada, tracking, TiempoPurga, TiempoPrueba, TPresion0, TPDeseada, Presion, PMax, TMuestreo,
             case status when 1 then 'OK' else 'NO OK' end as status_msg, grafica, id_grafica
      into   pHeat, pTracking, pPurgeTime, pTestTime, pZeroPressureTime, pDesiredPressureTime, pPressure, pMaxPressure, pSamplingTime, 
             pStatus, pGraph, vIdGraph
      from produccion_ph 
      where orden = pOP and progresivo = pProgressive and nfalla = pNumberOfTest;
      
      begin
         sp_ph_get_graph_test_zone(vIdGraph, pBeginningOfTestZone, pEndOfTestZone);
      exception
         when OTHERS then
         begin
            pBeginningOfTestZone := 0;  pEndOfTestZone := 0;
         end;
      end;
  else
      raise_application_error(-20001, 'There are no records in table PRODUCCION_PH with fields orden equal to ' || pOP || ' and progresivo equal to ' ||  pProgressive || ' and nfalla equal to ' || pNumberOfTest );
  end if;

END;
/
