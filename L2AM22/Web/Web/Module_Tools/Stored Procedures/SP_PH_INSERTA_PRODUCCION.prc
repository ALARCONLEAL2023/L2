CREATE OR REPLACE PROCEDURE SP_PH_INSERTA_PRODUCCION(pId_Identificacion in Number, pDesbloqueo in Number) IS

  v_MaxProgresivo Number;

  v_OrdenConRast  Number;
  v_NRegs         Number;
  v_Desbloqueo Number;

  vId_Orden      PH_IDENTIFICACIONES.ORDEN%TYPE;
  vId_Colada     PH_IDENTIFICACIONES.COLADA%TYPE;
  vId_Progresivo PH_IDENTIFICACIONES.PROGRESIVO%TYPE;
  vId_Tracking   PH_IDENTIFICACIONES.TRACKING%TYPE;
  vId_Producto   PH_IDENTIFICACIONES.PRODUCTO%TYPE;
  v_Rast         PRODUCCION_PH.RAST%TYPE;

  RegistroGrafica PH_GRAFICAS%ROWTYPE;

  CURSOR CursorGraficas IS
    select *
    from PH_GRAFICAS where id_identificacion = pId_Identificacion and borrada = 0
    order by num_prueba asc;

BEGIN

    -- IMPORTANTE: este procedimiento no debe tener manejo de excepciones propio
    -- porque la aplicacion que lo utiliza (adquisidor de PH) requiere de recibir sus
    -- excepciones a fin de hacer rollback a estas y otras operaciones que forman una
    -- misma transaccion.

    update PRODUCCION_PH set rast = 'E' where rast = 'P';

    select orden, colada, progresivo, tracking, producto
    into vId_Orden, vId_Colada, vId_Progresivo, vId_Tracking, vId_Producto
    from PH_IDENTIFICACIONES where id_identificacion = pId_Identificacion;

    v_NRegs := 0;
    select count(*) into v_NRegs from TBLCATORDENES_PH where orden = vId_Orden;
    if v_NRegs > 0 then
       select nvl(rastreo, 0) into v_OrdenConRast from TBLCATORDENES_PH where orden = vId_Orden;
    else
       v_NRegs := 0;
       select count(*) into v_NRegs from ph_presets where orden = vId_Orden and id_preset = (select nvl(max(id_preset),sysdate+1) from ph_presets where orden = vId_Orden and id_preset > sysdate - 2);
       if v_NRegs > 0 then
          select validar_etrack into v_OrdenConRast from ph_presets where orden = vId_Orden and id_preset = (select nvl(max(id_preset),sysdate+1) from ph_presets where orden = vId_Orden and id_preset > sysdate - 2);
       else          
          v_OrdenConRast := 0;
       end if;
    end if; 

    select nvl(max(Progresivo), 0)+1 into v_MaxProgresivo
    from PRODUCCION_PH where Orden = vId_Orden;

    --Verificando que si existan registros de grafica
    v_NRegs := 0;
    select count(*) into v_NRegs 
    from PH_GRAFICAS where id_identificacion = pId_Identificacion  and borrada = 0;
    if v_NRegs = 0 then
       raise_application_error(-20001, 'There are no records of graph in table PH_GRAFICAS with field id_identificacion equal to ' || pId_Identificacion);
    end if;

    OPEN CursorGraficas;
    FETCH CursorGraficas INTO RegistroGrafica;

    WHILE NOT CursorGraficas%NOTFOUND LOOP

       if (v_OrdenConRast = 1) and (RegistroGrafica.Status = 1) then
          v_Rast := 'P';
       else
          v_Rast := 'N';
       end if;

       if pDesbloqueo = 1 then
          v_Desbloqueo := 1;
       else
          v_Desbloqueo := RegistroGrafica.Desbloqueo_Tubo;
       end if;

       insert into PRODUCCION_PH(ORDEN, PROGRESIVO, MAQUINA, TRACKING, COLADA, FECHA, TURNO, HORAINI,
       HORAFIN, TIEMPOPURGA, TPDESEADA, TIEMPOPRUEBA, TPRESION0, STATUS, PRESION, NFALLA,
       INIPRUEBA, FINPRUEBA, TIEMPOCICLO, TMUESTREO, RAST, GRAFICA, PMAX, PMIN, PPROM, PROG_LINEAS, ID_GRAFICA, DESBLOQUEO_TUBO, VALIDACIONES, ID_TUBO, ID_IDENTIFICACION)
       values (vId_Orden, v_MaxProgresivo, 2, vId_Tracking, vId_Colada, getfechatamsa2_ph(RegistroGrafica.Horafin),
       getturno(RegistroGrafica.Horafin), RegistroGrafica.Horaini, RegistroGrafica.Horafin, RegistroGrafica.Tiempopurga,
       RegistroGrafica.Tpdeseada, RegistroGrafica.Tiempoprueba, RegistroGrafica.Tpresion0, RegistroGrafica.Status,
       RegistroGrafica.Presion, RegistroGrafica.Num_Prueba, RegistroGrafica.Iniprueba, RegistroGrafica.Finprueba,
       RegistroGrafica.Tiempociclo, RegistroGrafica.Tmuestreo, v_Rast, RegistroGrafica.Grafica, RegistroGrafica.Pmax,
       RegistroGrafica.Pmin, RegistroGrafica.Pprom, vId_Progresivo, RegistroGrafica.Id_Grafica, v_Desbloqueo, RegistroGrafica.Validaciones, RegistroGrafica.Id_Tubo, pId_Identificacion);

       FETCH CursorGraficas INTO RegistroGrafica;
    END LOOP;

    update PH_IDENTIFICACIONES set copiado_a_prod = 1, ordenamiento = -1 where id_identificacion = pId_Identificacion;

END SP_PH_INSERTA_PRODUCCION;
/
