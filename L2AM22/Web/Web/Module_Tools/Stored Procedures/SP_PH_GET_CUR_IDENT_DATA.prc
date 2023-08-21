CREATE OR REPLACE PROCEDURE SP_PH_GET_CUR_IDENT_DATA(
                                         pOrder out Varchar2, 
                                         pHeath out Varchar2, 
                                         pTracking out Varchar2, 
                                         pIdIdentification out Varchar2
                                         )
                                         IS
   vNumRows Number;                                                                              
BEGIN

    vNumRows := 0;
    select count(*) into vNumRows 
    from ph_identificaciones 
    where confirmado = 1 and copiado_a_prod = 0 order by orden_confirmacion asc;
    
    if vNumRows > 0 then
       select id_identificacion, orden, colada, tracking
         into pIdIdentification, pOrder, pHeath, pTracking 
       from ph_identificaciones 
       where confirmado = 1 and copiado_a_prod = 0 order by orden_confirmacion asc;
    else
       pOrder := '';
       pHeath := '';
       pTracking := '';
       pIdIdentification := '';
    end if;
    
EXCEPTION
   WHEN Others THEN
   Begin
       pOrder := '';
       pHeath := '';
       pTracking := '';
       pIdIdentification := '';
   End;             
END;
/
