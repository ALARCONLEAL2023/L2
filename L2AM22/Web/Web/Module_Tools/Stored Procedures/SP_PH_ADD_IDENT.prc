CREATE OR REPLACE PROCEDURE SP_PH_ADD_IDENT(
                                         pOrder in number,
                                         pHeat in number,
                                         pProduct in number,
                                         pCount in Number
                                         )
                                         IS
  /*****************************************************************
     Verifies if a given number of tracking belonging to certain order 
     is already registered into recent identifications
  ******************************************************************/
  vIndex Number;
BEGIN

     for vIndex in 1..pCount loop

        insert into ph_identificaciones( id_identificacion, orden, colada, tracking, producto )
        values (seq_ph_identificaciones.nextval, pOrder, pHeat, 0, pProduct);

     end loop;
     
     

END;
/
