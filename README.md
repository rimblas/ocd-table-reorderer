# OCD Table Reorderer

To the OCD developer in all of us.

## Install
This is a straightforward single page APEX app compatible with APEX 5.1

However, if you're on APEX 18.2 or beyond, you'll need to remove the JS line that references `jquery.ui.sortable.min.js` on the JavaScript File URLs section of p1. If you don't the drag and drop won't work.

## Roadmap
* Controls to move a column to the Beginning & End
* Pre-Defined column arrangements (like move Audit Columns to the end)


### Credits
The original script that kick this off is from (Dermot ONeill)[https://twitter.com/dermotoneill] with his (SQLcl)[https://www.oracle.com/database/technologies/appdev/sqlcl.html] (Aliases & The Invisible Column Trick)[http://dermotoneill.blogspot.co.uk/2015/11/sqlcl-aliases-invisible-column-trick.html].

I've shared his gem with many people, but then (Gemma Wood)[https://twitter.com/gemmawood] provided me with a pretty nice enhancement that moves the "Audit Columns" of a table to the end. You can (get that here)[scripts/apos.xml].  You can load it into SQLcl just like Dermont shows in his blog:

```
alias load c:\pos.xml
```


Finally, Gemma also had the idea... hey sometimes I just wish I could drag & drop the columns around....
