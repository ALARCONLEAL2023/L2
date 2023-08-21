CREATE OR REPLACE PROCEDURE SP_PH_GET_PRIVILEGES(
                                         sUserID in Varchar2,
                                         iIsAdministrator out Number
                                         )
                                         IS
  iNumRows number;
BEGIN

  iNumRows := 0;
  select count(*) into iNumRows from ADM_USER_ROLE where id_user = sUserID and id_role = 12;

  if iNumRows > 0 then
     iIsAdministrator := 1;
  else
     iIsAdministrator := 0;
  end if;

END;
/
