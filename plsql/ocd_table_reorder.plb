-- alter session set PLSQL_CCFLAGS='OOS_LOGGER:TRUE';
create or replace package body ocd_table_reorder
is


c_crlf      constant varchar2(30) := chr(13)||chr(10);

subtype col_name_t is varchar2(128);
subtype large_string_t is varchar2(32767);

type columns_rec_type is record (
    column_name  col_name_t
);

type column_tbl_type
  is table of columns_rec_type
  index by binary_integer;


procedure update_order(p_table_name in varchar2)
as
-- declare


  cols_arr column_tbl_type;

  started_moving boolean;
  g_curr_column col_name_t;
  g_full_sql large_string_t;
  
  procedure add_column(p_column_name in varchar2)
  is
    l_index  PLS_INTEGER;
  begin
    l_index := cols_arr.COUNT + 1;
    cols_arr(l_index).column_name := p_column_name;
  end add_column;

  procedure column_to_table_end (p_table_name in varchar2, p_column_name in varchar2)
  is
    l_sql_i  large_string_t;
    l_sql_v  large_string_t;

    e_visibility_cannot_be_changed exception;
    pragma exception_init (e_visibility_cannot_be_changed, -54041); 
  begin
    g_curr_column := p_column_name;
    $IF $$OOS_LOGGER $THEN
    logger.log('Moving ' || p_table_name || '.' || p_column_name);
    $END
    l_sql_i := 'alter table ' || p_table_name || ' modify (' || p_column_name;
    l_sql_v := l_sql_i || ' visible)';
    l_sql_i := l_sql_i || ' invisible)';

    execute immediate l_sql_i;
    execute immediate l_sql_v;

    g_full_sql := g_full_sql
               || l_sql_i || ';' || c_crlf
               || l_sql_v || ';' || c_crlf;
  -- exception
  --  when e_visibility_cannot_be_changed then
  --    -- log the error, but continue with the rest of the columns
  --    g_full_sql := g_full_sql || '-- Skipping column ' || p_column_name || c_crlf
  --               || '-- ' || sqlerrm || c_crlf;
  end column_to_table_end;

begin
  g_full_sql := null;
  g_curr_column := null;
  started_moving := false;

  g_full_sql := '-- Reordering ' || p_table_name || c_crlf;
  $IF $$OOS_LOGGER $THEN
  logger.log(g_full_sql);
  $END

  <<position>>
  for i in 1..apex_application.g_f01.count
  loop
    if not started_moving and i = apex_application.g_f01(i) then
       -- logger.log('Skipping ' || i);
       continue;
    else
      <<column_in_position>>
      $IF $$OOS_LOGGER $THEN
      logger.log('Will move ' || i);
      $END
      started_moving := true;
      for c in (
        select c.column_name
         from user_tab_columns c
        where c.table_name = p_table_name
          and c.column_id = to_number(apex_application.g_f01(i))
      )
      loop
        add_column(c.column_name);
      end loop column_in_position;
    end if;
  end loop position;


  for i in 1..cols_arr.COUNT loop
    column_to_table_end(p_table_name, cols_arr(i).column_name);
  end loop;


  apex_json.open_object;
  apex_json.write(
        p_name => 'success'
      , p_value => true
  );
  apex_json.write(
        p_name => 'sql'
      , p_value => g_full_sql
  );
  apex_json.close_object;
exception
  when OTHERS then

  apex_json.open_object;
  apex_json.write(
        p_name => 'success'
      , p_value => false
  );
  apex_json.write(
        p_name => 'message'
      , p_value => 'Column "' || g_curr_column || '" ' || sqlerrm
  );
  g_full_sql := g_full_sql || '-- Column: ' || g_curr_column || c_crlf || sqlerrm || c_crlf;

  apex_json.write(
        p_name => 'sql'
      , p_value => g_full_sql
  );
  apex_json.close_object;
end update_order;


end ocd_table_reorder;
/