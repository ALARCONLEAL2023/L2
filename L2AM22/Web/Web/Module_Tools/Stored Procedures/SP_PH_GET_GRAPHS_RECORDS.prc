CREATE OR REPLACE PROCEDURE SP_PH_GET_GRAPHS_RECORDS(
                                         RESULT OUT Pckcortadoras.Cursor_
                                         )
                                         IS
  /*****************************************************************
     Selects the last graphs generated that are not yet in production 
  ******************************************************************/
  Query   VARCHAR2(2000);
BEGIN

     Query :=
     ' select * from ( ' ||
     ' select id_grafica, producto, fecha, id_tubo, num_prueba, desbloqueo_tubo, preset_orden, ' ||
     ' p.presionn presion_de_prueba, P.tiempoprueba tiempo_de_prueba ' ||
     ' from ph_graficas g, (select presionn, tiempoprueba, cveprod from TBLCATPRODUCTOS_PH) p ' ||
     ' where p.cveprod (+) = g.producto and id_identificacion is null and borrada = 0 ' ||
     ' order by id_grafica asc ' ||
     ' ) where rownum <= 30 ';
 

  OPEN RESULT FOR Query;

END;
/
