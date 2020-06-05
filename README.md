# OCD Table Column Re-orderer

_To the OCD developer in all of us._

You have a carefully crafted table. Then the requirements change, as they always do, and you an important column to the table. Where does that column go? Well, at the end of the table of course.

Well, I say no more.

## Preview
![Alt text](/preview.gif?raw=true "Preview")


## Q&A
* Is it safe? I think so, I use it all the time but **USE AT YOUR OWN RISK**
* Is the data moved? No, not at all!
* Is a new table created? No, not at all!

## Install
This is a straightforward single page APEX app compatible with APEX 5.1.
Install the [ocd-table-column-reorder.sql](apex/ocd-table-column-reorder.sql)


### 18.2
If you're on APEX 18.2 or beyond, you'll need to **remove** the JS line that references `jquery.ui.sortable.min.js` on the JavaScript File URLs section of p1. It won't cause issues to leave it, but you'll get a 404 file not found error.

### 19.1
If you're on 19.1 or beyond, then you may want to change the `clearMessages` JS function to use `apex.theme42.util.configAPEXMsgs` instead of `apex.theme42.configureSuccessMessages`. But it's optional.

## Roadmap
* Controls to move a column to the Beginning & End
* Pre-Defined column arrangements (like move Audit Columns to the end)
* Block Move: select multiple columns that will move together


### Credits
The original script that kick this off is from [Dermot ONeill](https://twitter.com/dermotoneill) with his [SQLcl](https://www.oracle.com/database/technologies/appdev/sqlcl.html) [Aliases & The Invisible Column Trick](http://dermotoneill.blogspot.co.uk/2015/11/sqlcl-aliases-invisible-column-trick.html). Original [pos.xml](https://gist.github.com/dermotoneill/b654404f112846212d4d).

I've shared his gem with many people, but then [Gemma Wood](https://twitter.com/gemmawood) provided me with a pretty nice enhancement that moves the "Audit Columns" of a table to the end. You can [get that here](scripts/apos.xml).  You can load it into SQLcl just like Dermont shows in his blog:

```
alias load c:\apos.xml
```


Finally, Gemma also had the idea... hey sometimes I just wish I could drag & drop the columns around....
