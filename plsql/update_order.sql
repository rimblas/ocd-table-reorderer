declare

  type columns_rec_type is record (
      column_name  varchar2(128)
  );

  type column_tbl_type
    is table of columns_rec_type
    index by binary_integer;

  cols_arr column_tbl_type;

  procedure add_column(p_column_name in varchar2)
  is
    l_index  PLS_INTEGER;
  begin
    l_index := cols_arr.COUNT + 1;
    cols_arr(l_index).column_name := p_column_name;
  end add_column;

  procedure column_to_table_end (p_table_name in varchar2, p_column_name in varchar2)
  is
  begin
    dbms_output.put_line('Moving ' || p_column_name);
    logger.log('Moving ' || p_table_name || '.' || p_column_name);
    execute immediate 'alter table ' || p_table_name || ' modify (' || p_column_name || ' invisible)';
    execute immediate 'alter table ' || p_table_name || ' modify (' || p_column_name || ' visible)';
  end column_to_table_end;

begin
  logger.log('Reordering ' || :P1_TABLE_NAME);
  <<position>>
  for i in 1..apex_application.g_f01.count
  loop
    <<column_in_position>>
    for c in (
      select c.column_name
       from user_tab_columns c
      where c.column_id = apex_application.g_f01(i)
        and c.table_name = :P1_TABLE_NAME
    )
    loop
      add_column(c.column_name);
    end loop column_in_position;
  end loop position;


  for i in 1..cols_arr.COUNT loop
    column_to_table_end(:P1_TABLE_NAME, cols_arr(i).column_name);
  end loop;


  apex_json.open_object;
  apex_json.write(
        p_name => 'success'
      , p_value => true
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
      , p_value => sqlerrm
  );
  apex_json.close_object;
end;