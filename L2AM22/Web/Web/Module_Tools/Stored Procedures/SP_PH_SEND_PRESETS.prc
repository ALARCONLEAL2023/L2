CREATE OR REPLACE PROCEDURE SP_PH_SEND_PRESETS(
                                          pOrder in Number,
                                          pProduct in Number, 
                                          pPressureOfTest in Number, 
                                          pTimeOfTest in Number, 
                                          pTransferOrder in Number,
                                          pValidateGraphStored in Number, 
                                          pValidateGraphOK in Number, 
                                          pValidateIdentification in Number, 
                                          pValidateETrack in Number
                                         )
                                         IS
  vSequence Number;                                         
BEGIN
   
   select nvl(max(secuencia), 0)+1 into vSequence from ph_presets;

   insert into ph_presets(secuencia, orden, producto, presion_de_prueba, tiempo_de_prueba, transferir_orden, 
                          validar_grafica_grabada, validar_grafica_ok, validar_identificacion, validar_etrack) 
                   values(vSequence, pOrder, pProduct, pPressureOfTest, pTimeOfTest, pTransferOrder, 
                          pValidateGraphStored, pValidateGraphOK, pValidateIdentification, pValidateETrack);

END;
/
