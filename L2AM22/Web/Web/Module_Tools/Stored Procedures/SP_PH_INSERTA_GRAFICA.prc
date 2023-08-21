CREATE OR REPLACE PROCEDURE SP_PH_INSERTA_GRAFICA(pID_TUBO in Integer, pPRODUCTO in Integer, pGRAFICA in BLOB,
pNUM_PRUEBA in Number, pTIEMPOPURGA in Number, pTPDESEADA in Number, pTIEMPOPRUEBA in Number, pTPRESION0 in Number, pSTATUS in Number,
pPRESION in Number, pINIPRUEBA in Number, pFINPRUEBA in Number, pTIEMPOCICLO in Number, pTMUESTREO in Number,
pPMAX in Number, pPMIN in Number, pPPROM in Number, pHORAINI in Date, pHORAFIN in Date, pDESBLOQUEO_TUBO in Number, pVALIDACIONES in Number,
pPRESET_ORDER in Number) IS
  v_NumResg  Number;
BEGIN
     
     -- No considerar el campo BORRADA en este conteo ya que este borrada o no, debe considererse si lo que se desea validar es
     -- que ya haya sido insertada
     SELECT COUNT(*) into v_NumResg FROM PH_GRAFICAS where ID_TUBO = pID_TUBO and  NUM_PRUEBA = pNUM_PRUEBA and FECHA > sysdate - 0.1;
     
     if v_NumResg <= 0 then     
        INSERT INTO PH_GRAFICAS(ID_GRAFICA, ID_TUBO, PRODUCTO, GRAFICA, NUM_PRUEBA, TIEMPOPURGA, TPDESEADA, TIEMPOPRUEBA,
        TPRESION0, STATUS, PRESION, INIPRUEBA, FINPRUEBA, TIEMPOCICLO, TMUESTREO, PMAX, PMIN, PPROM, HORAINI, HORAFIN, DESBLOQUEO_TUBO, VALIDACIONES, PRESET_ORDEN )
        VALUES(SEQ_PH_GRAFICAS.NEXTVAL, pID_TUBO, pPRODUCTO, pGRAFICA, pNUM_PRUEBA, pTIEMPOPURGA, pTPDESEADA, pTIEMPOPRUEBA,
        pTPRESION0, pSTATUS, pPRESION, pINIPRUEBA, pFINPRUEBA, pTIEMPOCICLO, pTMUESTREO, pPMAX, pPMIN, pPPROM, pHORAINI, pHORAFIN, pDESBLOQUEO_TUBO, pVALIDACIONES, pPRESET_ORDER);
     else
         if pDESBLOQUEO_TUBO = 1 then  --- Grafica insertada por desbloqueo del tubo en la prueba
            update PH_GRAFICAS set DESBLOQUEO_TUBO = 1 where ID_TUBO = pID_TUBO and  NUM_PRUEBA = pNUM_PRUEBA and FECHA > sysdate - 0.1;
         else  --- Grafica insertada normalmente
            raise_application_error(-20000, 'Graph already exists with fields ID_TUBO='||pID_TUBO||' and  NUM_PRUEBA='||pNUM_PRUEBA||' in recent records of graphs');
         end if;        
     end if;

END SP_PH_INSERTA_GRAFICA;
/
