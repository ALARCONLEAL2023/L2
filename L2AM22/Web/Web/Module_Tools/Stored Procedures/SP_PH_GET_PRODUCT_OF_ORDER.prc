CREATE OR REPLACE PROCEDURE SP_PH_GET_PRODUCT_OF_ORDER(
                                         pOrder in number, 
                                         pProduct out Number
                                         )
                                         IS
  /*****************************************************************
     Selects the last graphs generated that are not yet in production 
  ******************************************************************/
  vNumRows Number;
  Query   VARCHAR2(2000);
BEGIN
     
     vNumRows := 0;
     select count(*) into vNumRows from tblcatordenes_ph where orden = pOrder;
     
     if vNumRows > 0 then
     
         select nvl(cveprod, 0) into pProduct  from tblcatordenes_ph where orden = pOrder;
         
     else
     
         vNumRows := 0;
         select count(*) into vNumRows from ph_presets 
         where orden = pOrder 
               and id_preset = (select nvl(max(id_preset),sysdate+1) from ph_presets where orden = pOrder and id_preset > sysdate - 2);
               
         if vNumRows > 0 then
            select nvl(producto,0) into vNumRows from ph_presets 
            where orden = pOrder 
                  and id_preset = (select nvl(max(id_preset),sysdate+1) from ph_presets where orden = pOrder and id_preset > sysdate - 2);
         else
            pProduct := 0;
         end if;
         
     end if;

END;
/
