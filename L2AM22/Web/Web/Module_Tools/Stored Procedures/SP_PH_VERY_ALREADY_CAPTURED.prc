CREATE OR REPLACE PROCEDURE SP_PH_VERY_ALREADY_CAPTURED(
                                         pCaptureWindowOfTime in Number,
                                         pOrder in number, 
                                         pTracking in Number,
                                         pNumFoundRecs out Number
                                         )
                                         IS
  /*****************************************************************
     Verifies if a given number of tracking belonging to certain order 
     is already registered into recent identifications
  ******************************************************************/
BEGIN
     
     select count(*) into pNumFoundRecs from ph_identificaciones 
     where fecha > sysdate - pCaptureWindowOfTime and orden = pOrder and tracking = pTracking;

END;
/
