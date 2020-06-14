
-- Run in SQLcl
set termout off
define APP_ID = 107

apex export &APP_ID.
host mv f&APP_ID..sql ocd-table-column-reorder-app.sql
exit