CREATE OR REPLACE PROCEDURE SP_PH_GET_CUR_GRAPH_STATUS(
                                         pIdTube in Number,
                                         pNumberOfTests in Number,
                                         pStatus out Number
                                         )
                                         IS
   vNumRows Number;                                                                              
BEGIN

    vNumRows := 0;
    select count(*) into vNumRows
    from ph_graficas 
    where id_tubo = pIdTube and num_prueba = pNumberOfTests and  borrada = 0 and fecha > sysdate - 0.1;
    
    if vNumRows > 0 then

       select status into pStatus from ph_graficas 
       where id_tubo = pIdTube and num_prueba = pNumberOfTests and  borrada = 0 and fecha > sysdate - 0.1;

    else
       pStatus := -1;
    end if;
    
EXCEPTION
    WHEN Others THEN
    Begin
       pStatus := -1;
    End;
END;
/
