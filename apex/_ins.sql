-- *** APEX ***
PROMPT *** APEX Installation ***

set serveroutput on size unlimited;
begin

  apex_application_install.set_workspace('MASTERMIND_DEV');
  apex_application_install.set_application_id(151);
  apex_application_install.set_schema('SAPIEN_APEX');
  apex_application_install.generate_offset;
end;
/
@ocd-table-column-reorder-app.sql