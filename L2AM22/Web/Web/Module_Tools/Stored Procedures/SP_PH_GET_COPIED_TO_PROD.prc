CREATE OR REPLACE PROCEDURE SP_PH_GET_COPIED_TO_PROD(
                                         RESULT OUT Pckcortadoras.Cursor_,
                                         pNumRecords in Number
                                         )
                                         IS
  /*****************************************************************
     Selects the last pNumRecords already copied to production
  ******************************************************************/
  vMaxConfirmationOrder Number;
  Query   VARCHAR2(2000);
BEGIN

     begin
        select nvl(max(orden_confirmacion), 0) into vMaxConfirmationOrder from ph_identificaciones where copiado_a_prod = 1;
     exception
        when others then
           vMaxConfirmationOrder := 0;
     end;

     vMaxConfirmationOrder := vMaxConfirmationOrder - pNumRecords;
     if vMaxConfirmationOrder < 0 then
        vMaxConfirmationOrder := 0;
     end if;

     Query :=
     ' select g.id_grafica as id_grafica, g.producto as producto, g.fecha as fecha, g.id_tubo, g.num_prueba, g.preset_orden, ' ||
     ' i.id_identificacion as id_identificacion, i.orden as orden, i.colada as colada, i.tracking as tracking, ' ||
     ' p.presionn presion_de_prueba, p.tiempoprueba tiempo_de_prueba ' ||
     ' from ph_graficas g, (select presionn, tiempoprueba, cveprod from TBLCATPRODUCTOS_PH) p, ph_identificaciones i ' ||
     ' where p.cveprod (+) = g.producto and g.id_identificacion = i.id_identificacion ' ||
     ' and copiado_a_prod = 1 and orden_confirmacion > ' || vMaxConfirmationOrder ||
     ' order by orden_confirmacion asc ';
 

  OPEN RESULT FOR Query;

END;
/
