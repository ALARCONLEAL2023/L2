CREATE OR REPLACE PROCEDURE SP_PH_SET_TRACE_OF_ORDER(
                                          pOrder in Number
                                         )
                                         IS
BEGIN

   update tblcatordenes_ph set rastreo = 1, rast_etrack = 1 where orden = pOrder;

END;
/
