CREATE OR REPLACE PROCEDURE SP_PH_ACCIONAMIENTOS  (pid_tubo in number
  , pcve_acc_1 in number, pseg_ini_1 in number, pseg_fin_1 in number, pcve_acc_2 in number, pseg_ini_2 in number, pseg_fin_2 in number
  , pcve_acc_3 in number, pseg_ini_3 in number, pseg_fin_3 in number, pcve_acc_4 in number, pseg_ini_4 in number, pseg_fin_4 in number
  , pcve_acc_5 in number, pseg_ini_5 in number, pseg_fin_5 in number, pcve_acc_6 in number, pseg_ini_6 in number, pseg_fin_6 in number
  , pcve_acc_7 in number, pseg_ini_7 in number, pseg_fin_7 in number, pcve_acc_8 in number, pseg_ini_8 in number, pseg_fin_8 in number
  , pcve_acc_9 in number, pseg_ini_9 in number, pseg_fin_9 in number, pcve_acc_10 in number, pseg_ini_10 in number, pseg_fin_10 in number
  , pcve_acc_11 in number, pseg_ini_11 in number, pseg_fin_11 in number, pcve_acc_12 in number, pseg_ini_12 in number, pseg_fin_12 in number  
  , pcve_acc_13 in number, pseg_ini_13 in number, pseg_fin_13 in number  
  )
 IS

  v_orden number;
  v_progresivo number;
  v_id_tubo number;
  v_id_tubo_prev number;

  RegistroAccionamiento tbltempaccionamientos_ph%ROWTYPE;

  CURSOR CursorAccionamientos IS
    select * 
    from tbltempaccionamientos_ph 
    where id_tubo in 
    (select distinct nvl(id_tubo,-1) from produccion_ph where horafin > sysdate - 0.2);

BEGIN

    -- insertar accionamientos en tabla temporal
    insert into tbltempaccionamientos_ph(id_tubo, cve_acc, seg_ini, seg_fin) values(pid_tubo, pcve_acc_1, pseg_ini_1, pseg_fin_1);
    insert into tbltempaccionamientos_ph(id_tubo, cve_acc, seg_ini, seg_fin) values(pid_tubo, pcve_acc_2, pseg_ini_2, pseg_fin_2);
    insert into tbltempaccionamientos_ph(id_tubo, cve_acc, seg_ini, seg_fin) values(pid_tubo, pcve_acc_3, pseg_ini_3, pseg_fin_3);
    insert into tbltempaccionamientos_ph(id_tubo, cve_acc, seg_ini, seg_fin) values(pid_tubo, pcve_acc_4, pseg_ini_4, pseg_fin_4);
    insert into tbltempaccionamientos_ph(id_tubo, cve_acc, seg_ini, seg_fin) values(pid_tubo, pcve_acc_5, pseg_ini_5, pseg_fin_5);
    insert into tbltempaccionamientos_ph(id_tubo, cve_acc, seg_ini, seg_fin) values(pid_tubo, pcve_acc_6, pseg_ini_6, pseg_fin_6);
    insert into tbltempaccionamientos_ph(id_tubo, cve_acc, seg_ini, seg_fin) values(pid_tubo, pcve_acc_7, pseg_ini_7, pseg_fin_7);
    insert into tbltempaccionamientos_ph(id_tubo, cve_acc, seg_ini, seg_fin) values(pid_tubo, pcve_acc_8, pseg_ini_8, pseg_fin_8);
    insert into tbltempaccionamientos_ph(id_tubo, cve_acc, seg_ini, seg_fin) values(pid_tubo, pcve_acc_9, pseg_ini_9, pseg_fin_9);
    insert into tbltempaccionamientos_ph(id_tubo, cve_acc, seg_ini, seg_fin) values(pid_tubo, pcve_acc_10, pseg_ini_10, pseg_fin_10);
    insert into tbltempaccionamientos_ph(id_tubo, cve_acc, seg_ini, seg_fin) values(pid_tubo, pcve_acc_11, pseg_ini_11, pseg_fin_11);
    insert into tbltempaccionamientos_ph(id_tubo, cve_acc, seg_ini, seg_fin) values(pid_tubo, pcve_acc_12, pseg_ini_12, pseg_fin_12);
    insert into tbltempaccionamientos_ph(id_tubo, cve_acc, seg_ini, seg_fin) values(pid_tubo, pcve_acc_13, pseg_ini_13, pseg_fin_13);            

    -- ver si hay nuevos registros en produccion
    v_id_tubo := -1;
    v_id_tubo_prev := -1;
    OPEN CursorAccionamientos;
    FETCH CursorAccionamientos INTO RegistroAccionamiento;

    WHILE NOT CursorAccionamientos%NOTFOUND LOOP

       v_id_tubo := RegistroAccionamiento.id_tubo;

       if v_id_tubo <> v_id_tubo_prev then
          select orden, progresivo into v_orden, v_progresivo from produccion_ph 
          where horafin > sysdate - 1 and id_tubo = RegistroAccionamiento.id_tubo and rownum = 1;
       end if;

       insert into tblhistaccionamientos_ph(op, prog, cve_acc, seg_ini, seg_fin)
       values(v_orden, v_progresivo, RegistroAccionamiento.cve_acc, RegistroAccionamiento.seg_ini, RegistroAccionamiento.seg_fin);

       delete from tbltempaccionamientos_ph where id_tubo = RegistroAccionamiento.id_tubo and cve_acc = RegistroAccionamiento.cve_acc;

       v_id_tubo_prev := v_id_tubo;

       FETCH CursorAccionamientos INTO RegistroAccionamiento;
    END LOOP;
EXCEPTION 
    WHEN OTHERS THEN NULL;
END SP_PH_ACCIONAMIENTOS;
/
