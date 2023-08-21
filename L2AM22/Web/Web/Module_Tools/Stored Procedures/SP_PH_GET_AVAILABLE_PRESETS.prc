CREATE OR REPLACE PROCEDURE SP_PH_GET_AVAILABLE_PRESETS(
                                          RESULT OUT Pckcortadoras.Cursor_,
                                          pOffsetForAvailablePresets in Number
                                         )
                                         IS
  Query  VARCHAR2(2000);
BEGIN
   
   Query :=
   ' select fecha, id_preset, orden, producto, presion_de_prueba, tiempo_de_prueba ' ||
   '       , case transferir_orden when 1 then ''SI'' else ''NO'' end as transferir_orden ' ||
   '       , case validar_grafica_grabada when 1 then ''SI'' else ''NO'' end as validar_grafica_grabada ' ||
   '       , case validar_grafica_ok when 1 then ''SI'' else ''NO'' end as validar_grafica_ok ' ||
   '       , case validar_identificacion when 1 then ''SI'' else ''NO'' end as validar_identificacion ' ||
   '       , case validar_etrack when 1 then ''SI'' else ''NO'' end as validar_etrack ' ||
   ' from ph_presets_descargados ' ||
   ' where fecha >= (select case when GETTURNO(sysdate) = 1 then to_date(to_char(GETFECHATAMSA2_PH(SYSDATE)) || '' 06:00:00'',''dd/mm/rrrr hh24:mi:ss'')-(' || pOffsetForAvailablePresets || '/1440) ' ||
   '      when GETTURNO(sysdate) = 2 then to_date(to_char(GETFECHATAMSA2_PH(SYSDATE)) || '' 14:00:00'',''dd/mm/rrrr hh24:mi:ss'')-(' || pOffsetForAvailablePresets || '/1440) ' ||
   '      when GETTURNO(sysdate) = 3 then to_date(to_char(GETFECHATAMSA2_PH(SYSDATE)) || '' 22:00:00'',''dd/mm/rrrr hh24:mi:ss'')-(' || pOffsetForAvailablePresets || '/1440) ' ||
   '      end from dual) ' ||
   ' order by id_preset desc ';
   
  OPEN RESULT FOR Query;

END;
/
