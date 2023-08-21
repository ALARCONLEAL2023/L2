create or replace procedure SP_PH_TUBOS_OP(pOP in integer, pCursor out pckPH.CursorAux) is
begin

  OPEN pCursor FOR
  SELECT
   Orden, Colada, Progresivo, HoraFin, tracking, Nfalla, Fecha, Turno, Status,
   TiempoPurga, TiempoPrueba, TPresion0, TPDeseada, Presion, FinPrueba, TiempoCiclo, TMuestreo,   
   case Status when 1 then 'OK' else 'NO OK' end as Estado,  grafica
  FROM
   PRODUCCION_PH o
  WHERE
   Orden = pOP;

end SP_PH_TUBOS_OP;
/
