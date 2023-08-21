CREATE OR REPLACE PROCEDURE SP_PH_GET_PRESETS_HISTORY( RESULT OUT Pckcortadoras.Cursor_,
                                          pOP in VarChar2,
                                          pProduct in VarChar2,
                                          pPressureOfTest in VarChar2,
                                          pTimeOfTest in VarChar2,
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
    CadenaSelect :=
     ' select id_preset, secuencia, orden, producto, presion_de_prueba, tiempo_de_prueba ' ||
     ' , case transferir_orden when 1 then ''SI'' else ''NO'' end as transferir_orden ' ||
     ' , case validar_grafica_grabada when 1 then ''SI'' else ''NO'' end as validar_grafica_grabada ' ||
     ' , case validar_grafica_ok when 1 then ''SI'' else ''NO'' end as validar_grafica_ok ' ||
     ' , case validar_identificacion when 1 then ''SI'' else ''NO'' end as validar_identificacion ' ||
     ' , case validar_etrack when 1 then ''SI'' else ''NO'' end as validar_etrack ' ||
     ' from ph_presets ';
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

    if not pProduct is null then
        if Bandera = 0 then
           CadenaWhere := CadenaWhere || ' producto = ' || pProduct;
           Bandera := 1;
        else
           CadenaWhere := CadenaWhere || ' and producto = ' || pProduct;
        end if;
    end if;

    if not pPressureOfTest is null then
        if Bandera = 0 then
           CadenaWhere := CadenaWhere || ' presion_de_prueba = ' || pPressureOfTest;
           Bandera := 1;
        else
           CadenaWhere := CadenaWhere || ' and presion_de_prueba = ' || pPressureOfTest;
        end if;
    end if;

    if not pTimeOfTest is null then
        if Bandera = 0 then
           CadenaWhere := CadenaWhere || ' tiempo_de_prueba = ' || pTimeOfTest;
           Bandera := 1;
        else
           CadenaWhere := CadenaWhere || ' and tiempo_de_prueba = ' || pTimeOfTest;
        end if;
    end if;

    if pUsePeriod = 'Y' then

        if not pDateFrom is null then
            if Bandera = 0 then
               CadenaWhere := CadenaWhere || ' id_preset >= ' || sDateFrom || ' ';
               Bandera := 1;
            else
               CadenaWhere := CadenaWhere || ' and id_preset >= ' || sDateFrom || ' ';
            end if;
        end if;

        if not pDateTo is null then
            if Bandera = 0 then
               CadenaWhere := CadenaWhere || ' id_preset <= ' || sDateTo || ' ';
               Bandera := 1;
            else
               CadenaWhere := CadenaWhere || ' and id_preset <= ' || sDateTo || ' ';
            end if;
        end if;

    end if;

  /************************************************************
  Ordenamiento de los resultados
  ************************************************************/
    if pOrdering = 'A' then
       CadenaWhere := CadenaWhere || ' order by id_preset asc ';
    else
       CadenaWhere := CadenaWhere || ' order by id_preset desc ';
    end if;

    if Bandera = 1 then
       CadenaSelect := CadenaSelect || ' where ' || CadenaWhere;
    else
       CadenaSelect := CadenaSelect || CadenaWhere;
    end if;

  OPEN RESULT FOR CadenaSelect;

END;
/
