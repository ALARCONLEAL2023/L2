CREATE OR REPLACE PROCEDURE SP_PH_VALI_LAST_ERROR(
                                         pValidation in Varchar2,
                                         pDate out Date,
                                         pError out Varchar2
                                         )
                                         IS
   vNumRows Number;
   vOrder Number;
   vHeath Number;
   vProgressive Number;
   vNumOfTest Number;
   vTracking Number;
   vDate Date;
   vMessage Varchar2(255);
   vIdTube Number;
   vValidation Varchar2(30);
BEGIN

    if pValidation = 'GraphStored' then
       vValidation := 'GraficaGrabada';
    end if;

    if pValidation = 'TestOK' then
       vValidation := 'GraficaOk';
    end if;

    if pValidation = 'Identification' then
       vValidation := 'Identificacion';
    end if;

    if pValidation = 'eTrack' then
       vValidation := 'eTrack';
    end if;

    vNumRows := 0;

    select count(*) into vNumRows
    from PH_AVISOS where tipo = vValidation
    and fecha = (select max(fecha) from PH_AVISOS where tipo = vValidation);

    if vNumRows > 0 then

       select orden, colada, progresivo, num_prueba, tracking, fecha, mensaje, id_tubo
       into vOrder, vHeath, vProgressive, vNumOfTest, vTracking, vDate, vMessage, vIdTube
       from PH_AVISOS where tipo = vValidation
       and fecha = (select max(fecha) from PH_AVISOS where tipo = vValidation);

       pDate := vDate;

       pError := vMessage || '. ';

       if vOrder <> -1 then
           pError := pError || ' Orden:' || vOrder;
       end if;

       if vHeath <> -1 then
           pError := pError || ' Colada:' || vHeath;
       end if;
       
       if vProgressive <> -1 then
           pError := pError || ' Progresivo:' || vProgressive;
       end if;
       
       if vNumOfTest <> -1 then
           pError := pError || ' Numero de prueba:' || vNumOfTest;
       end if;

       if vTracking <> -1 then
           pError := pError || ' Tracking:' || vTracking;
       end if;

       if vIdTube <> -1 then
           pError := pError || ' IdTubo:' || vIdTube;
       end if;

    else
       pDate := sysdate-10;
       pError := 'Ningun error registrado.';
    end if;
EXCEPTION
   WHEN Others THEN
   Begin
      pDate := sysdate-10;
      pError := 'Error durante busqueda. Haga clic en el error nuevamente.';
   end;
END;
/
