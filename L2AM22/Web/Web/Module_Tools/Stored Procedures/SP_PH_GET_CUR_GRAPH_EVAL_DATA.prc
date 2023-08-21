CREATE OR REPLACE PROCEDURE SP_PH_GET_CUR_GRAPH_EVAL_DATA(
                                         pTimeOfSampling out Number, 
                                         pSampleNumberLastOverpressure out Number, 
                                         pSampleNumberBeginOfTest out Number, 
                                         pSampleNumberEndOfTest out Number, 
                                         pPressure out Number, 
                                         pMaximumPressure out Number, 
                                         pGraph out Blob
                                         )
                                         IS
   vNumRows Number;                                                                              
BEGIN

    vNumRows := 0;
    select count(*) into vNumRows
    from ph_graficas where id_grafica = (select max(id_grafica) from ph_graficas where borrada = 0 );
    
    if vNumRows > 0 then

       select tmuestreo, muestra_ult_sobr, muestra_ini_prueba, muestra_fin_prueba, presion, pmax, grafica 
         into pTimeOfSampling, pSampleNumberLastOverpressure, pSampleNumberBeginOfTest, 
              pSampleNumberEndOfTest, pPressure, pMaximumPressure, pGraph
       from ph_graficas where id_grafica = (select max(id_grafica) from ph_graficas where borrada = 0 );

    else
       raise_application_error(-20001, 'There is no record as shold be for current graph');
    end if;
    
END;
/
