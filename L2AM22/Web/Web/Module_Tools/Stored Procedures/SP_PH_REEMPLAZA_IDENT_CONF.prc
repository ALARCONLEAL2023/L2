CREATE OR REPLACE PROCEDURE SP_PH_REEMPLAZA_IDENT_CONF(pIdReplacement in Number, pReplacementData out Varchar) IS

    v_IdConfirmed       PH_IDENTIFICACIONES.ID_IDENTIFICACION%TYPE;
    v_ConfirmationOrder PH_IDENTIFICACIONES.ORDEN_CONFIRMACION%TYPE;
    v_Order             PH_IDENTIFICACIONES.ORDEN%TYPE;
    v_Heat              PH_IDENTIFICACIONES.COLADA%TYPE;
    v_Progressive       PH_IDENTIFICACIONES.PROGRESIVO%TYPE;
    v_Tracking          PH_IDENTIFICACIONES.TRACKING%TYPE;
    v_Product           PH_IDENTIFICACIONES.PRODUCTO%TYPE;

    v_Order_Conf        PH_IDENTIFICACIONES.ORDEN%TYPE;
    v_Heat_Conf         PH_IDENTIFICACIONES.COLADA%TYPE;
    v_Progressive_Conf  PH_IDENTIFICACIONES.PROGRESIVO%TYPE;
    v_Tracking_Conf     PH_IDENTIFICACIONES.TRACKING%TYPE;
    v_Product_Conf      PH_IDENTIFICACIONES.PRODUCTO%TYPE;

BEGIN

    begin
        v_ConfirmationOrder := -1;

        select nvl(min(orden_confirmacion), -1) into v_ConfirmationOrder from PH_IDENTIFICACIONES
        where confirmado = 1 and copiado_a_prod = 0;

        if v_ConfirmationOrder <> -1 then
            select nvl(id_identificacion, -1), nvl(orden, -1), nvl(colada, -1), nvl(progresivo, -1), nvl(tracking, -1), nvl(producto, -1) 
            into v_IdConfirmed, v_Order_Conf, v_Heat_Conf, v_Progressive_Conf, v_Tracking_Conf, v_Product_Conf 
            from PH_IDENTIFICACIONES
            where confirmado = 1 and copiado_a_prod = 0 and orden_confirmacion = v_ConfirmationOrder;

            if v_IdConfirmed <> -1 then
                select orden, colada, progresivo, tracking, producto into v_Order, v_Heat, v_Progressive, v_Tracking, v_Product
                from PH_IDENTIFICACIONES
                where id_identificacion = pIdReplacement;

                update PH_IDENTIFICACIONES set orden = v_Order, colada = v_Heat, progresivo = v_Progressive, tracking = v_Tracking, producto = v_Product
                where id_identificacion = v_IdConfirmed;

                delete from PH_IDENTIFICACIONES where id_identificacion = pIdReplacement;
                
                begin
                     pReplacementData := 'Conf: Id-' || v_IdConfirmed || ' ord-' || v_Order_Conf || ' col-' || v_Heat_Conf || ' trk-' || v_Tracking_Conf || ' prog-' || v_Progressive_Conf || ' prod-' || v_Product_Conf || 
                                         '   Reemp: Id-' || pIdReplacement || ' ord-' || v_Order || ' col-' || v_Heat || ' trk-' || v_Tracking || ' prog-' || v_Progressive || ' prod-' || v_Product ;
                exception
                   when OTHERS then
                   begin
                        pReplacementData := '';
               	   end;
                end;
   
            else
                raise_application_error(-20001, 'No hay registro confirmado que reemplazar');
            end if;
        else
            raise_application_error(-20001, 'No hay registro confirmado que reemplazar');
        end if;
   end;

END SP_PH_REEMPLAZA_IDENT_CONF;
/
