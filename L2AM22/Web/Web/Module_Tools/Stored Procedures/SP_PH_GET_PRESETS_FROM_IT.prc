CREATE OR REPLACE PROCEDURE SP_PH_GET_PRESETS_FROM_IT(
                                          pOP in Number,
                                          pProduct out Varchar2,
                                          pPressureOfTest out Varchar2,
                                          pTimeOfTest out Varchar2,
                                          pETrack out Varchar2
                                         )
                                         IS

  vNumRows Number;
BEGIN

   vNumRows := 0;
   select count(*) into vNumRows
   from v_datosop_ph where orden = pOP;

   if vNumRows > 0 then
      select cveprod, presionn, tiempoprueba, case rastreo when 1 then 'Y' else 'N' end
      into pProduct, pPressureOfTest, pTimeOfTest, pETrack
      from v_datosop_ph where orden = pOP;
   else
      pProduct := '?';
      pPressureOfTest := '?';
      pTimeOfTest := '?';
      pETrack := '?';
   end if;

EXCEPTION
   WHEN Others THEN
   Begin
      pProduct := '?';
      pPressureOfTest := '?';
      pTimeOfTest := '?';
      pETrack := '?';
   End;
END;
/
