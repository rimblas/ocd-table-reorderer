
-- Run in SQLcl
set termout off
define APP_ID = 108

apex export &APP_ID.
host mv f108.sql ocd-table-column-reorder-app.sql
exit