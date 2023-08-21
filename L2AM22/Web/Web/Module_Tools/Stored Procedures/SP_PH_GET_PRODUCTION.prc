CREATE OR REPLACE PROCEDURE SP_PH_GET_PRODUCTION( RESULT OUT Pckcortadoras.Cursor_,
                                          pOP in VarChar2,
                                          pHeat in VarChar2,
                                          pProgressive in VarChar2,
                                          pNumberOfTest in VarChar2,
                                          pTracking in VarChar2,
                                          pOrdering in VarChar2,
                                          pDateFrom in Date,
                                          pDateTo in Date,
                                          pUsePeriod in VarChar2
                                         )
                                         IS

  Bandera       Number;
  CadenaSelect  VARCHAR2(2000);
  CadenaWhere   VARCHAR2(2000);
  sDateFrom     VARCHAR2(100);
  sDateTo       VARCHAR2(100);
BEGIN


  /***********************************
  Formateado de la fecha
  ***********************************/
    sDateFrom := ' To_Date(''' || To_Char(pDateFrom, 'DD/MM/YYYY HH24:MI:SS') || ''', ''DD/MM/YYYY HH24:MI:SS'')';
    sDateTo := ' To_Date(''' || To_Char(pDateTo, 'DD/MM/YYYY HH24:MI:SS') || ''', ''DD/MM/YYYY HH24:MI:SS'')';

  /***********************************
  Formando la parte inicial de la consulta
  ***********************************/
    CadenaSelect := ' select orden, colada, progresivo, horafin, tracking, case status when 1 then ''OK'' else ''NO OK'' end as status_msg, status, nfalla, desbloqueo_tubo from produccion_ph ';
    CadenaWhere := '';

  /***********************************
  Agregando a la consulta segun los parametros recibidos
  ***********************************/
    Bandera := 0;

    if not pOP is null  then
        if Bandera = 0 then
           CadenaWhere := CadenaWhere || ' orden = ' || pOP;
           Bandera := 1;
        else
           CadenaWhere := CadenaWhere || ' and orden = ' || pOP;
        end if;
    end if;

    if not pHeat is null then
        if Bandera = 0 then
           CadenaWhere := CadenaWhere || ' colada = ' || pHeat;
           Bandera := 1;
        else
           CadenaWhere := CadenaWhere || ' and colada = ' || pHeat;
        end if;
    end if;

    if not pProgressive is null then
        if Bandera = 0 then
           CadenaWhere := CadenaWhere || ' progresivo = ' || pProgressive;
           Bandera := 1;
        else
           CadenaWhere := CadenaWhere || ' and progresivo = ' || pProgressive;
        end if;
    end if;

    if not pNumberOfTest is null then
        if Bandera = 0 then
           CadenaWhere := CadenaWhere || ' nfalla = ' || pNumberOfTest;
           Bandera := 1;
        else
           CadenaWhere := CadenaWhere || ' and nfalla = ' || pNumberOfTest;
        end if;
    end if;

    if not pTracking is null then
        if Bandera = 0 then
           CadenaWhere := CadenaWhere || ' tracking = ' || pTracking;
           Bandera := 1;
        else
           CadenaWhere := CadenaWhere || ' and tracking = ' || pTracking;
        end if;
    end if;

    if pUsePeriod = 'Y' then

        if not pDateFrom is null then
            if Bandera = 0 then
               CadenaWhere := CadenaWhere || ' horafin >= ' || sDateFrom || ' ';
               Bandera := 1;
            else
               CadenaWhere := CadenaWhere || ' and horafin >= ' || sDateFrom || ' ';
            end if;
        end if;

        if not pDateTo is null then
            if Bandera = 0 then
               CadenaWhere := CadenaWhere || ' horafin <= ' || sDateTo || ' ';
               Bandera := 1;
            else
               CadenaWhere := CadenaWhere || ' and horafin <= ' || sDateTo || ' ';
            end if;
        end if;

    end if;

  /************************************************************
  Ordenamiento de los resultados
  ************************************************************/
    if pOrdering = 'A' then
       CadenaWhere := CadenaWhere || ' order by horafin asc ';
    else
       CadenaWhere := CadenaWhere || ' order by horafin desc ';
    end if;

    if Bandera = 1 then
       CadenaSelect := CadenaSelect || ' where ' || CadenaWhere;
    else
       CadenaSelect := CadenaSelect || CadenaWhere;
    end if;

  OPEN RESULT FOR CadenaSelect;

END;
/
