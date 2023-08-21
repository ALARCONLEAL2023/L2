CREATE OR REPLACE PROCEDURE SP_PH_GET_ORDER_DATA(
                                         pOrder in Number,
                                         pClient out Varchar2, 
                                         pDiameter out Varchar2, 
                                         pSteelKey out Varchar2, 
                                         pWidth out Varchar2
                                         )
                                         IS
   vNumRows Number;                                                                              
BEGIN

    vNumRows := 0;
    select count(*) into vNumRows from v_datosop_ph where orden = pOrder;
    
    if vNumRows > 0 then
       select nombcte, diamfracc, cveacero, espesor into pClient, pDiameter, pSteelKey, pWidth
       from v_datosop_ph where orden = pOrder;
    else
       pClient := '?'; 
       pDiameter := '?'; 
       pSteelKey := '?'; 
       pWidth := '?'; 
    end if;
    
EXCEPTION
   WHEN Others THEN
   Begin
      pClient := '?'; 
      pDiameter := '?'; 
      pSteelKey := '?'; 
      pWidth := '?'; 
   End;             
END;
/
