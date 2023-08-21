CREATE OR REPLACE PROCEDURE SP_PH_VERIFICA_ETRACK(pOrder in Number, pHeat in Number, pTracking in Number, pResult out Number, pComment out Varchar) IS

  v_ClaveProceso          Varchar(100);
  v_Status                Varchar(100);
  v_Avanza                Number;
  v_Comentario            Varchar(300);

BEGIN
    begin
       v_ClaveProceso := 'PHL2';
       v_Status       := 'P';

       if pTracking > 0 then
          SP_TUBO_DESDE_N2@rast.world (pOrder, pHeat, v_ClaveProceso, pTracking, v_Status, 0, v_Avanza, v_Comentario, 'NivelII');
          if v_Avanza = 0 and SUBSTR(LTRIM(v_Comentario),1,2) = 'PH' then
             v_Comentario := 'La ruta no contiene Prueba Hidraulica';
          end if;
          --rast_sp_tubos_state_ph(v_Orden, v_ClaveProceso, v_Tracking, v_Status, 0, v_Avanza, v_Comentario, 'NivelII');
       else
          v_Avanza  := 0;
          v_Comentario := 'El numero de tracking no puede ser cero';
       end if;

       pResult     := v_Avanza;
       pComment    := v_Comentario;
       commit;

    exception
       when OTHERS then
       begin
          rollback;
          pResult  := -1;
          pComment := 'Exception' || SUBSTR(SQLERRM,1,200);
 	     end;
   end;
END SP_PH_VERIFICA_ETRACK;
/
