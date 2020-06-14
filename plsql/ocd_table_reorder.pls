create or replace package ocd_table_reorder
authid current_user
is

procedure update_order(p_table_name in varchar2);

end ocd_table_reorder;
/