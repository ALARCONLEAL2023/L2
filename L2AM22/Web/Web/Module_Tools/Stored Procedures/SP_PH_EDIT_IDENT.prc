CREATE OR REPLACE PROCEDURE SP_PH_EDIT_IDENT(
                                         pOrder in Varchar2,
                                         pHeath in Varchar2,
                                         pTracking in Varchar2,
                                         pProduct in Varchar2,
                                         pIdIdentification in Number
                                         )
                                         IS
  /*****************************************************************
     Performs editions on some fields of an identification record
  ******************************************************************/
  Query   VARCHAR2(2000);
  vFirst   Number;
BEGIN

     Query :=
     ' update ph_identificaciones set ';

      vFirst := 1;
     
      if not pOrder is null then
          if vFirst = 1 then
             Query := Query || ' orden = ' || pOrder; 
             vFirst := 0; 
          else 
             Query := Query || ', orden = ' || pOrder;
          end if;
      end if;
      
      if not pHeath is null then
          if vFirst = 1 then
             Query := Query || ' colada = ' || pHeath; 
             vFirst := 0; 
          else 
             Query := Query || ', colada = ' || pHeath;
          end if;
      end if;
      
      if not pTracking is null then
          if vFirst = 1 then
             Query := Query || ' tracking = ' || pTracking; 
             vFirst := 0;
          else 
             Query := Query || ', tracking = ' || pTracking;
          end if;
      end if;

      if not pProduct is null then
          if vFirst = 1 then
             Query := Query || ' producto = ' || pProduct; 
             vFirst := 0;
          else 
             Query := Query || ', producto = ' || pProduct;
          end if;
      end if;

      Query := Query || ' where id_identificacion = ' || pIdIdentification;

  EXECUTE IMMEDIATE Query;



END;
/
