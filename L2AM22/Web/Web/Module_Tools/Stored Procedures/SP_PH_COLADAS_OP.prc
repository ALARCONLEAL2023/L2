create or replace procedure SP_PH_COLADAS_OP(pOrden in number :=null, pColada in number := null, pCursor out pckPH.CursorAux) is
vQuery varchar2(2000);
begin

  vQuery := ' select orden, colada, cveprod, presionn, tiempoprueba, pzas from v_datoscoladasop_ph ';

  if ( pOrden is not null ) or ( pColada is not null ) then
      vQuery := vQuery || ' where ';
      if ( pOrden is not null ) then
         vQuery := vQuery || ' orden=' || pOrden;
      end if;

      if ( pColada is not null ) then
         if ( pOrden is not null ) then
            vQuery := vQuery || ' and colada=' || pColada;
         else
            vQuery := vQuery || ' colada=' || pColada;
         end if;
      end if;
  end if;

  vQuery := vQuery || ' order by orden, colada';

  OPEN pCursor FOR vQuery;

end SP_PH_COLADAS_OP;
/
