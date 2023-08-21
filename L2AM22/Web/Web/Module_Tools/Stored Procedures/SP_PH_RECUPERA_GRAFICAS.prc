CREATE OR REPLACE PROCEDURE SP_PH_RECUPERA_GRAFICAS IS

  v_MaxProgresivo Number;

  v_OrdenConRast  Number;
  v_Desbloqueo Number;

  vId_Orden      PH_IDENTIFICACIONES.ORDEN%TYPE;
  vId_Colada     PH_IDENTIFICACIONES.COLADA%TYPE;
  vId_Progresivo PH_IDENTIFICACIONES.PROGRESIVO%TYPE;
  vId_Tracking   PH_IDENTIFICACIONES.TRACKING%TYPE;
  vId_Producto   PH_IDENTIFICACIONES.PRODUCTO%TYPE;
  v_Rast         PRODUCCION_PH.RAST%TYPE;

  RegistroGrafica PH_GRAFICAS%ROWTYPE;

    CURSOR CursorGraficas IS
    select * from ph_graficas where fecha > to_date('2007/11/15 22:00:00','yyyy/mm/dd hh24:mi:ss')
    and fecha < to_date('2007/11/16 06:00:00','yyyy/mm/dd hh24:mi:ss')
    order by fecha asc;

BEGIN

    -- IMPORTANTE: este procedimiento no debe tener manejo de excepciones propio
    -- porque la aplicacion que lo utiliza (adquisidor de PH) requiere de recibir sus
    -- excepciones a fin de hacer rollback a estas y otras operaciones que forman una
    -- misma transaccion.

    vId_Orden := 127598;
    vId_Colada := 1;
    vId_Progresivo := 0;
    vId_Tracking := 0;
    vId_Producto := 36820;
    v_Rast := 'S';
    v_Desbloqueo := 0;
    v_OrdenConRast := 0;

    select nvl(max(Progresivo), 0)+1 into v_MaxProgresivo
    from PRODUCCION_PH where Orden = vId_Orden;

    OPEN CursorGraficas;
    FETCH CursorGraficas INTO RegistroGrafica;

    WHILE NOT CursorGraficas%NOTFOUND LOOP
       
       begin       
           insert into PRODUCCION_PH(ORDEN, PROGRESIVO, MAQUINA, TRACKING, COLADA, FECHA, TURNO, HORAINI,
           HORAFIN, TIEMPOPURGA, TPDESEADA, TIEMPOPRUEBA, TPRESION0, STATUS, PRESION, NFALLA,
           INIPRUEBA, FINPRUEBA, TIEMPOCICLO, TMUESTREO, RAST, GRAFICA, PMAX, PMIN, PPROM, PROG_LINEAS, ID_GRAFICA, DESBLOQUEO_TUBO, VALIDACIONES, ID_TUBO)
           values (vId_Orden, v_MaxProgresivo, 2, vId_Tracking, vId_Colada, getfechatamsa2_ph(RegistroGrafica.Horafin),
           getturno(RegistroGrafica.Horafin), RegistroGrafica.Horaini, RegistroGrafica.Horafin, RegistroGrafica.Tiempopurga,
           RegistroGrafica.Tpdeseada, RegistroGrafica.Tiempoprueba, RegistroGrafica.Tpresion0, RegistroGrafica.Status,
           RegistroGrafica.Presion, RegistroGrafica.Num_Prueba, RegistroGrafica.Iniprueba, RegistroGrafica.Finprueba,
           RegistroGrafica.Tiempociclo, RegistroGrafica.Tmuestreo, v_Rast, RegistroGrafica.Grafica, RegistroGrafica.Pmax,
           RegistroGrafica.Pmin, RegistroGrafica.Pprom, vId_Progresivo, RegistroGrafica.Id_Grafica, v_Desbloqueo, RegistroGrafica.Validaciones, RegistroGrafica.Id_Tubo);
       exception
          when others then
          begin
             v_MaxProgresivo := v_MaxProgresivo + 1;
             
             insert into PRODUCCION_PH(ORDEN, PROGRESIVO, MAQUINA, TRACKING, COLADA, FECHA, TURNO, HORAINI,
             HORAFIN, TIEMPOPURGA, TPDESEADA, TIEMPOPRUEBA, TPRESION0, STATUS, PRESION, NFALLA,
             INIPRUEBA, FINPRUEBA, TIEMPOCICLO, TMUESTREO, RAST, GRAFICA, PMAX, PMIN, PPROM, PROG_LINEAS, ID_GRAFICA, DESBLOQUEO_TUBO, VALIDACIONES, ID_TUBO)
             values (vId_Orden, v_MaxProgresivo, 2, vId_Tracking, vId_Colada, getfechatamsa2_ph(RegistroGrafica.Horafin),
             getturno(RegistroGrafica.Horafin), RegistroGrafica.Horaini, RegistroGrafica.Horafin, RegistroGrafica.Tiempopurga,
             RegistroGrafica.Tpdeseada, RegistroGrafica.Tiempoprueba, RegistroGrafica.Tpresion0, RegistroGrafica.Status,
             RegistroGrafica.Presion, RegistroGrafica.Num_Prueba, RegistroGrafica.Iniprueba, RegistroGrafica.Finprueba,
             RegistroGrafica.Tiempociclo, RegistroGrafica.Tmuestreo, v_Rast, RegistroGrafica.Grafica, RegistroGrafica.Pmax,
             RegistroGrafica.Pmin, RegistroGrafica.Pprom, vId_Progresivo, RegistroGrafica.Id_Grafica, v_Desbloqueo, RegistroGrafica.Validaciones, RegistroGrafica.Id_Tubo);
          end;
       end;


       FETCH CursorGraficas INTO RegistroGrafica;
       
       if RegistroGrafica.Num_Prueba = 1 then
          v_MaxProgresivo := v_MaxProgresivo + 1;
       end if;
       
    END LOOP;


END SP_PH_RECUPERA_GRAFICAS;
/
