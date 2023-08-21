create or replace procedure SP_PH_REENVIA_ETRACK is

  RegistroReenvioETrack PRODUCCION_PH%ROWTYPE;

  CURSOR CursorReenvioETrack IS
    select * from PRODUCCION_PH
    where RAST = 'E' and HORAFIN > sysdate - 0.05;

  v_ClaveProceso          Varchar(100);
  v_Status                Varchar(100);
  v_Avanza                Number;
  v_Comentario            Varchar(300);

begin

    OPEN CursorReenvioETrack;
    FETCH CursorReenvioETrack INTO RegistroReenvioETrack;

    WHILE NOT CursorReenvioETrack%NOTFOUND LOOP

          v_ClaveProceso := 'PHL2';
          v_Status       := 'A';

          SP_TUBO_DESDE_N2@rast.world (RegistroReenvioETrack.ORDEN, RegistroReenvioETrack.Colada, v_ClaveProceso, RegistroReenvioETrack.Tracking, v_Status, 0, v_Avanza, v_Comentario, 'NivelII');
          --rast_sp_tubos_state_ph(RegistroReenvioETrack.ORDEN, v_ClaveProceso, RegistroReenvioETrack.TRACKING, v_Status, 0, v_Avanza, v_Comentario, 'NivelII');

          if v_Avanza = 1 then
             update PRODUCCION_PH set rast = 'S'
             where RAST = 'E' and ORDEN = (RegistroReenvioETrack.ORDEN) and PROGRESIVO=(RegistroReenvioETrack.PROGRESIVO) and NFALLA=(RegistroReenvioETrack.NFALLA);
             COMMIT;
          end if;

       FETCH CursorReenvioETrack INTO RegistroReenvioETrack;
    END LOOP;

  Exception
  When OTHERS Then
     begin
        ROLLBACK;
        NULL;
     end;
end SP_PH_REENVIA_ETRACK;
/
