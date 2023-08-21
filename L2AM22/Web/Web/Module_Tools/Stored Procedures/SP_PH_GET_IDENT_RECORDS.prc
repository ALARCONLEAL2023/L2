CREATE OR REPLACE PROCEDURE SP_PH_GET_IDENT_RECORDS(
                                         RESULT OUT Pckcortadoras.Cursor_
                                         )
                                         IS
  /*****************************************************************
     Selects the last identifications entered by operator that are not yet in production 
  ******************************************************************/
  Query   VARCHAR2(2000);
BEGIN

     Query :=
     ' select * from ( ' ||
     ' select id_identificacion, orden, colada, tracking ' ||
     ' from ph_identificaciones ' ||
     ' where confirmado = 0 and copiado_a_prod = 0 ' ||
     ' order by ordenamiento desc, fecha asc ' ||
     ' ) where rownum <= 100 ';


  OPEN RESULT FOR Query;

END;
/
