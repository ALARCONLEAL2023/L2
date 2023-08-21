CREATE OR REPLACE PROCEDURE SP_PH_VERY_TUBE_IN_ETRACK(
                                         pIdIdentification in Number, 
                                         pResult out Number, 
                                         pComment out Varchar2
                                         )
                                         IS
  /*****************************************************************
     Verifies the data of an identification against the etrack system.
     Also, verifies wheter such verification is necessary according to 
     the settings for the order
  ******************************************************************/
  vNumRows                 Number;
  vOrder                   Number;
  vHeath                   Number;
  vTracking                Number;
  vOrderHasETrackInPresets Number;
  vOrderHasETrackInCatalog Number;
  v_ProcessKey             Varchar(100);
  v_Status                 Varchar(100);
  v_Advance                Number;
  v_Comment                Varchar(300);

BEGIN



     -- Getting corresponding order, heat and tracking
         vNumRows := 0;
         
         select count(*) into vNumRows
         from ph_identificaciones where id_identificacion = pIdIdentification;
         
         if vNumRows > 0 then
            select orden, colada, tracking into vOrder, vHeath, vTracking 
            from ph_identificaciones where id_identificacion = pIdIdentification;
         else
            raise_application_error(-20001, 'There are no records of identification in table PH_IDENTIFICACIONES with field id_identificacion equal to ' || pIdIdentification);
         end if;
         
     -- Verifying if record of order in presets has etrack
         vNumRows := 0;
         
         select count(*) into vNumRows from ph_presets 
         where orden = vOrder and id_preset = 
         (select nvl(max(id_preset),sysdate+1) from ph_presets where orden = vOrder and id_preset > sysdate - 2);
     
         if vNumRows > 0 then
            select validar_etrack into vOrderHasETrackInPresets from ph_presets 
            where orden = vOrder and id_preset = 
            (select nvl(max(id_preset),sysdate+1) from ph_presets where orden = vOrder and id_preset > sysdate - 2);
         else
             vOrderHasETrackInPresets := 0;
         end if;
         
     -- Verifying if record of order in catalog has etrack
         vNumRows := 0;

         select count(*) into vNumRows from TBLCATORDENES_PH where ORDEN = vOrder;
         if vNumRows > 0 then
            select RASTREO into vOrderHasETrackInCatalog from TBLCATORDENES_PH where ORDEN = vOrder;
         else
            vOrderHasETrackInCatalog := 0;
         end if;
        
     -- Conditions when tube has not to be verified in etrack system
        if vTracking = 0 then

            if (vOrderHasETrackInPresets = 1) or (vOrderHasETrackInCatalog = 1) then
                pResult := 0;
                pComment := 'Los tubos de la orden ' || vOrder || ' deben llevar numero de tracking no cero';
                return;
            end if;

            -- If the tracking of tube is cero and its order has no traceability set,
            -- the verification about traceability is OK
            pResult := 1;
            pComment := '';
            return;

        else -- if vTracking != 0

            -- If the tracking of tube is not cero and its order has no traceability set,
            -- the verification about traceability is OK
            if (vOrderHasETrackInPresets <> 1) and (vOrderHasETrackInCatalog <> 1) then
                pResult := 1;
                pComment := '';
                return;
            end if;
            
        end if;
     
     -- Verification of tube in etrack system
        begin
            v_ProcessKey := 'PHL2';
            v_Status       := 'P';
     
            if vTracking > 0 then
               SP_TUBO_DESDE_N2@rast.world (vOrder, vHeath, v_ProcessKey, vTracking, v_Status, 0, v_Advance, v_Comment, 'NivelII');
               if v_Advance = 0 and SUBSTR(LTRIM(v_Comment),1,2) = 'PH' then
                  v_Comment := 'La ruta no contiene Prueba Hidraulica';
               end if;
               --rast_sp_tubos_state_ph(v_Orden, v_ClaveProceso, v_Tracking, v_Status, 0, v_Avanza, v_Comentario, 'NivelII');
            else
               v_Advance  := 0;
               v_Comment := 'El numero de tracking no puede ser cero';
            end if;
     
            pResult     := v_Advance;
            pComment    := v_Comment;
            commit;
     
         exception
            when OTHERS then
            begin
               rollback;
               pResult  := -1;
               pComment := 'Exception' || SUBSTR(SQLERRM,1,200);
      	     end;
        end;

END;
/
