CREATE OR REPLACE PROCEDURE SP_PH_ADD_PRESETS(
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
BEGIN
   
   insert into ph_presets_descargados(id_preset, orden, producto, presion_de_prueba, tiempo_de_prueba, transferir_orden, 
                                      validar_grafica_grabada, validar_grafica_ok, validar_identificacion, validar_etrack) 
                               values(seq_presets_descargados.nextval, pOrder, pProduct, pPressureOfTest, pTimeOfTest, pTransferOrder, 
                                      pValidateGraphStored, pValidateGraphOK, pValidateIdentification, pValidateETrack);

END;
/
