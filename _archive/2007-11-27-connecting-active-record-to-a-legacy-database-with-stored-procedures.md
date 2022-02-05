---
title: "Connecting Active Record to a Legacy Database with Stored Procedures"
author: Mikel Lindsaar
date: 2007-11-27
layout: post
redirect_from:
  - /2007/11/27/connecting-active-record-to-a-legacy-database-with-stored-procedures
  - /2007/11/26/connecting-active-record-to-a-legacy-database-with-stored-procedures
---
Sometimes you just have to go ahead and do it the hard way.

The last three days was that time for me. I had to write an application
that interfaced with an existing MS SQLServer system, and I couldn't
change the schema of any existing table... what to do? Well... I can
tell you it was a lesson in the difference between being opinionated
software and bigoted software...

I first sat down and looked at the existing schema with it's lack of
documentation it was interesting finding the relationships between the
tables and records.

It is a respectable size database with a bunch of tables and hundreds of
stored procedures for most anything you needed to do.

Luckily, while ActiveRecord is opinionated about the way it should do
things, it is not a Bigot, and with it's parent Rails, we were able to
massage this app into existence.

First step was identifying what it was I actually needed to do and
isolating the tables involved, ensuring I wasn't stepping on any other
toes around this quite populated database.

Then, looking through the existing tables and records finding
relationships and drawing them out on paper so I could see in 2
dimensions what the original author of the DB meant.

Then, as I had to develop on a Windows box for this, I grabbed a copy of
e (nothing compared to Textmate) and populated my temporary Windows
system with the One Click Ruby installed, Rails, the Win32 Gem library
and some others I like (RSpec et al). Also had to install Cygwin for e
to run specs properly.

Next step? Installing a local copy of SQL server and pulling down a copy
of the DB to work on.

OK... I was all set.

Now in the editor, I first created a bunch of models, one for each table
I had to model in my App. As NONE of these tables were puralized, and
NONE of them followed the Rails convention of primary_key being an auto
incrementing integer column called :id, I made very good use of the two
override methods which override the primary_key value as well as the
table_name value, basically making ActiveRecord ignore the convention of
a pluralized underscorized classname for the table and id as the primary
key.

``` ruby
class MyClassName < ActiveRecord::Base

  set_primary_key => "my_table_primary_id"
  set_table_name  => "new_table_name"

end
```

There was one of these in EVERY model.

Now, the down side of using the above is that Rails no longer will
automagically maintain the :id column, which means you have to set it.

So instead of:

``` ruby
MyTableName.create(:name => "Bob", :age => "10")
```

You now have to do:

``` ruby
MyTableName.create(:my_table_primary_id => 1, :name => "Bob", :age => "10")
```

Note, it wants the primary key column set explicitly by name.

OK, so now I had my models in place, I started putting relationships in.

The one to many relationships were easy enough, by using the foreign_key
param.

``` ruby
has_many :other_records, :foreign_key => my_special_foreign_key
```

But it was the has_many through that started causing problems. Here I
resorted to using SQL on the exisitng stored procedures to fight my way
through the code and get the products I needed.

Additionally, the way you got a unique primary_key_id was a stored
procedure. SO that meant running stored procedures in the code.

This stored procedure accepted the table name you wanted a new primary
key for as well as an SQL variable to dump the result into. So you had
to call it in SQL like this:

``` sql
exec get_id "my_table_name", @id output
```

Just running an ActiveRecord.connection.execute(the_aboe_sql_code) did
not produce the result of the next ID, because SQL Server would complain
that \@id didn't exist (and rightly so, I didn't declare it...), so
instead I had to do something like this:

``` ruby
sql_query = "set nocount on;\n" +
"declare @id integer;\n" +
"exec get_primary_key 'my_table_name', @id output;\n" +
"select @id;"
result = ActiveRecord.connection.select_value(sql_query)
```

This then dumped the id into the result variable which we could then
whack into the create method. What the "set nocount on" does is tells
SQLServer to suppress the output of "1 rows affected" after the
execution of the stored procedure.

Leaving that inside the create method was a bit scary, so I moved it
into a class method like so:

``` ruby
class MyClassName < ActiveRecord::Base

  set_primary_key => "my_table_primary_id"
  set_table_name  => "new_table_name"

  class << self

    def get_next_id
      sql_query = "set nocount on;\n" +
      "declare @id integer;\n" +
      "exec get_id 'my_table_name', @id output;\n" +
      "select @id;"

      ActiveRecord.connection.select_value(sql_query)
    end

  end

end
```

Now I can call MyClassName.get_next_id to get the next unique primary
key for the table. This is a bit neater, but not really a solution. What
would be cool is being able to set inside a model an override method
which tells the class how to get the next primary key. But that is a
subject for another post.

blogLater

Mikel

