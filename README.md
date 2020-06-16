# OCD Table Column Re-orderer

_To the [OCD](https://www.mayoclinic.org/diseases-conditions/obsessive-compulsive-disorder/symptoms-causes/syc-20354432) developer in all of us._

You have a carefully crafted table. Then the requirements change, as they always do, and you an important column to the table. Where does that column go? Well, at the end of the table of course.

Well, I say no more.

## Preview
![Functionality Preview](/preview.gif?raw=true "Preview")

![Schema Switching](/docs/images/ocd-schema-switch-preview.gif?raw=true "Schema Switch Preview")


## Q&A
* Is it safe? I think so, I use it all the time but **USE AT YOUR OWN RISK**
* Is the data moved? No, not at all!
* Is a new table created? No, not at all!

## Install
This is a straightforward single page APEX app.
Install the [ocd-table-column-reorder.sql](apex/ocd-table-column-reorder.sql) application.

The application will install the package [`ocd_table_reorder`](plsql/ocd_table_reorder.plb) as part of the installation or upgrade as a supporting object.


If you have multiple schemas on your Workspace you can either:
   * Install the package on each schema
   * Create a synonym and grants

```
connect ORIGINAL_SCHEMA
grant execute on ocd_table_reorder to NEW_SCHEMA;
connect NEW_SCHEMA
create synonym ocd_table_reorder for ORIGINAL_SCHEMA.ocd_table_reorder;
```

[See a video](https://www.youtube.com/watch?v=KYMun3YObrI) of the switching between schemas feature implementation.


This app now requires APEX 18.2 (but you could trivially backport to 18.1 if needed)

For APEX 5.1 see [Release v1.01](releases/tag/v1.01).


### 19.1 or beyond
You'll want to **remove** the JS line that references `jquery.ui.sortable.min.js` on the JavaScript File URLs section of p1. It won't cause issues to leave it, but you'll get a 404 file not found error.

If you're on 19.1 or beyond, then you may want to change the `clearMessages` JS function to use `apex.theme42.util.configAPEXMsgs` instead of `apex.theme42.configureSuccessMessages`. But it's optional.


## Pre-Requisites

The functionality to re-order the columns depends on the [Invisible Columns](https://oracle-base.com/articles/12c/invisible-columns-12cr1) feature of Oracle Databace 12c.

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
