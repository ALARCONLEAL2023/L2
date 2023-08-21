CREATE OR REPLACE PROCEDURE SP_PH_ENVIA_ETRACK(pOrder in out Number, pTracking in out Number, pResult out Number, pComment out Varchar, pProgressive out Number, pNumberOfTests out Number) IS

  v_NumeroDeRegistros     Number;
  v_PrimeraFechaFin       Date;

  v_ClaveProceso          Varchar(100);
  v_Status                Varchar(100);
  v_Avanza                Number;
  v_Comentario            Varchar(300);

  v_Orden      PRODUCCION_PH.ORDEN%TYPE;
  v_Colada     PRODUCCION_PH.COLADA%TYPE;
  v_Tracking   PRODUCCION_PH.TRACKING%TYPE;
  v_Progresivo PRODUCCION_PH.PROGRESIVO%TYPE;
  v_NFalla     PRODUCCION_PH.NFALLA%TYPE;
  v_IdTubo     PRODUCCION_PH.ID_TUBO%TYPE;  

BEGIN

    begin
    
        select count(*) into v_NumeroDeRegistros from PRODUCCION_PH where RAST = 'P' and TRACKING = pTracking and ORDEN = pOrder;
    
        if v_NumeroDeRegistros > 0 then
              if v_NumeroDeRegistros = 1 then
                 select ORDEN, TRACKING, PROGRESIVO, COLADA, NFALLA, ID_TUBO into v_Orden, v_Tracking, v_Progresivo, v_Colada, v_NFalla, v_IdTubo from PRODUCCION_PH where RAST = 'P' and TRACKING = pTracking and ORDEN = pOrder;
              else
                  select min(HORAFIN) into v_PrimeraFechaFin from PRODUCCION_PH where RAST = 'P';
                  select ORDEN, TRACKING, PROGRESIVO, COLADA, NFALLA, ID_TUBO into v_Orden, v_Tracking, v_Progresivo, v_Colada, v_NFalla, v_IdTubo from PRODUCCION_PH where RAST = 'P' and TRACKING = pTracking and ORDEN = pOrder and HORAFIN = v_PrimeraFechaFin;
              end if;
    
              v_ClaveProceso := 'PHL2';
              v_Status       := 'A';
    
              if v_Tracking > 0 then              
                 begin
                    SP_TUBO_DESDE_N2@rast.world (v_Orden, v_Colada, v_ClaveProceso, v_Tracking, v_Status, 0, v_Avanza, v_Comentario, 'NivelII');
                    if v_Avanza = 0 and SUBSTR(LTRIM(v_Comentario),1,2) = 'PH' then
                       v_Comentario := 'La ruta no contiene Prueba Hidraulica';
                    end if;
                 exception
          	        when OTHERS then
          		      begin
           	           v_Comentario := SUBSTR(SQLERRM,1,200);
          			       v_Avanza :=-1;
                       pOrder       := v_Orden;
                       pTracking    := v_Tracking;
                       pResult   := v_Avanza;
                       pComment     := v_Comentario;
                       pProgressive := v_Progresivo;
                       pNumberOfTests := v_NFalla;
                       return;                       
          			    end;          
          	     end;
                  --rast_sp_tubos_state_ph(v_Orden, v_ClaveProceso, v_Tracking, v_Status, 0, v_Avanza, v_Comentario, 'NivelII');
              else
                  v_Comentario := 'Field Tracking is cero for order= ' || v_Orden || ', progressive= ' || v_Progresivo || ', number of test= ' || v_NFalla;
              end if;
              
              if v_Avanza = 1 then
                 update PRODUCCION_PH set rast = 'S' where RAST = 'P' and ORDEN = v_Orden and TRACKING = v_Tracking;
                 
                 insert into PH_ETRACK(ID_ENVIO, ORDEN, COLADA, PROGRESIVO, NUM_PRUEBA, TRACKING, RESPUESTA, SISTEMA, RESULTADO, ID_TUBO) 
                 values(SEQ_PH_ETRACK.NEXTVAL, v_Orden, v_Colada, v_Progresivo, v_NFalla, v_Tracking, v_Comentario, 'eTrack', v_Avanza, v_IdTubo);
              end if;
              
              if (v_Avanza = 1) or (v_Avanza = 0)  then
                 pOrder       := v_Orden;
                 pTracking    := v_Tracking;
                 pResult   := v_Avanza;
                 pComment     := v_Comentario;
                 pProgressive := v_Progresivo;
                 pNumberOfTests := v_NFalla;
                 return;
              end if;              
              
        else
            v_Comentario := 'No record found with tracking = ' || pTracking || ' to send to eTrack  (RAST = ''P'' missing)';
        end if;
        
        pOrder      := 0;
        pTracking   := 0;
        pResult     := 0;
        pComment    := v_Comentario;
        pProgressive := 0;
        pNumberOfTests := 0;
        
    exception
     when OTHERS then
     begin
           pOrder      := -1;
           pTracking   := -1;
           pResult  := -1;
           pComment := 'Exception' || SUBSTR(SQLERRM,1,200);
           pProgressive := 0;
           pNumberOfTests := 0;
 	   end;
   end;
       
END SP_PH_ENVIA_ETRACK;
/
