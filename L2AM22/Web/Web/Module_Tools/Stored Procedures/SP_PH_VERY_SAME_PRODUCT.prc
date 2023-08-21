CREATE OR REPLACE PROCEDURE SP_PH_VERY_SAME_PRODUCT(
                                         pIdTube in number,
                                         pIdIdentification in number,
                                         pValidateProductsAttributes in number,
                                         pAreTheSame out number
                                         )
                                         IS
  /*****************************************************************
     Verifies if a given pair graph-identification match on their products
     of on the attributes (pressure and time of test) of their products
  ******************************************************************/
  vProductFromGraph Number;
  vProductFromIdentification Number;
  vPressureFromGraph Number;
  vPressureFromIdentification Number;
  vTimeOfTestFromGraph Number;
  vTimeOfTestFromIdentification Number;
BEGIN

     select producto into vProductFromGraph
     from ph_graficas where id_identificacion is null and id_tubo = pIdTube;
     
     select producto into vProductFromIdentification
     from ph_identificaciones where id_identificacion = pIdIdentification;
     
     if vProductFromGraph = vProductFromIdentification then
        pAreTheSame := 1;
     else
        if pValidateProductsAttributes = 1 then
        
            select presionn, tiempoprueba into vPressureFromGraph, vTimeOfTestFromGraph 
            from tblcatproductos_ph where cveprod = vProductFromGraph;
           
            select presionn, tiempoprueba into vPressureFromIdentification, vTimeOfTestFromIdentification 
            from tblcatproductos_ph where cveprod = vProductFromIdentification;
            
            if (vPressureFromGraph = vPressureFromIdentification) and (vTimeOfTestFromGraph = vTimeOfTestFromIdentification) then
               pAreTheSame := 1;
            else
               pAreTheSame := 0;
            end if;
        else
            pAreTheSame := 0;
        end if;
     end if;

END;
/
