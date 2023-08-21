CREATE OR REPLACE PROCEDURE SP_PH_GET_GRAPHS_TUBES_COUNT (
                                                           pNumGraphs out number,
                                                           pNumTubes out number
) IS

BEGIN

  pNumGraphs := 0;
  pNumTubes := 0;
                                                           
  select count(*) into pNumGraphs
  from ph_graficas where id_identificacion is null and borrada = 0;
  
  select count(*) into pNumTubes from
  (
  select distinct id_tubo
  from ph_graficas where id_identificacion is null and borrada = 0 );

END;
/
