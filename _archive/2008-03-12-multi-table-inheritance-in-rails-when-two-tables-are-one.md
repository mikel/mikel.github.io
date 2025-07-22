---
title: "Multi-Table Inheritance in Rails - When two tables are one..."
author: Mikel Lindsaar
date: 2008-03-12
layout: home
redirect_from:
  - /2008/3/12/multi-table-inheritance-in-rails-when-two-tables-are-one
---
I had a situation where I had two tables, one was read only data and the
other was where I would put my new data. They both modeled the same
object (a person) but I had to figure out how to have ONE object for the
system to interact with.

That is, how do you make two tables into one model in Rails?

#### MULTI-TABLE INHERITANCE!!!!!

You see, Rails gives you so many ways to fake it! Using a bit of Ruby
inheritance goodness, some PostgreSQL view sweetness and a dolop of open
source "look into the insides of the source code and see what is
happening" cleverness, I got my product and it works! (I know, amazing,
don't tell my boss).

Say you have two tables, lets call the first one external_people, the
other one internal_people. Both of them relate to the same object (a
person), but they are updated from different sources. external_people is
a dump from another system, internal_people is where you save, read,
write and update your records. But you only really want one interface to
this. You don't want to be able to do things like:

``` ruby
Person.find(:all, :conditions => "first_name = ?", 'Mikel')
```

And have the system look through BOTH tables and return you people
objects that are (1) mapped to the right table (external or internal)
and (2) have the appropriate set of sub features (the external table is
read only, the internal table is read write).

Well, this is surprisingly easy in rails.

First, we need to make the ExternalPerson and InternalPerson classes:

``` ruby
class ExternalPerson < Person
end
```

and

``` ruby
class InternalPerson < Person
end
```

Of course, also make their tables. Notice how they inherit from the
Person class? I guess we better make that one then, for originality,
lets go out on a limb and call it.. umm.. 'Person'. I know, I know...
shockingly unique, right?

``` ruby
class Person < ActiveRecord::Base
end
```

Not much of a class yet...

Now, instead of a table, we want the Person class to use a view. If you
are not sure what a view is, think of it as a predefined SQL query. It
is basically *any* query you want that you can access like a table in a
select query. So you can do:

``` sql
SELECT * FROM view_name JOIN some_other_table... <blah> WHERE <blah>;
```

Which makes it a perfect substitute for our situation.

So out to the command prompt and 'script/generate migration
create_people_view' and hit that return button!

Now, we put our SQL code we need to do to make the PostgreSQL view:

``` ruby
class CreatePeopleView < ActiveRecord::Migration
  def self.up
    sql_statement =<<-HEREEND
    CREATE OR REPLACE VIEW people AS
      SELECT external_table.id, external_table.first_name,
             external_table.last_name, external_table.class_name
             FROM external_table
      UNION ALL
      SELECT internal_table.id, internal_table.first_name,
             internal_table.last_name, internal_table.class_name
             FROM internal_table;

      COMMENT ON VIEW people IS
        'Provide a combined view of the external and internal people tables';
    HEREEND

    execute(sql_statement)
  end

  def self.down
    execute('DROP VIEW people;')
  end
end
```

The UNION ALL is a command that basically takes one tables contents,
adds it to the other and gives you the result with no further
inspection. There is another command called 'UNION' which will do that

*and* remove duplicates, but that obviously has a performance hit.

I have no idea if the above code will work on MySQL or SQLite, I haven't
tried, would be interesting to know.

Notice also the 'class_name' value in each of the tables, that holds a
string in the format of a Ruby Class name, in our case 'ExternalPerson'
and 'InternalPerson', this is because we want to track what table each
one came from. To create them, I used this migration:

``` ruby
class AddClassNamesToPeopleTables < ActiveRecord::Migration
  def self.up

    add_column :external_people, :class_name, :string, :default => 'ExternalPerson'
    add_column :internal_people, :class_name, :string, :default => 'InternalPerson'

    sql_statement =<<-HEREEND
    UPDATE external_people SET class_name = 'ExternalPerson';
    UPDATE internal_people SET class_name = 'InternalPerson';
    HEREEND

    execute(sql_statement)
  end

  def self.down
    remove_column :external_people, :class_name
    remove_column :internal_people, :class_name
  end
end
```

Ok, that looks like it might work. So run the migrations with 'rake
db:migrate' and jump into console and check it out:

``` shell
baci:~/app mikel$ ./script/console
Loading development environment (Rails 2.0.2)
>> @person = Person.find(:first)
=> #<Person id: 1, first_name: 'Mikel', last_name:
'Lindsaar' :class_name 'ExternalPerson' .....
```

Looks good! Notice the class_name attribute that will now follow this
record around?

Now, there are two problems with this.

-   What happens if we have two ids that are the same on both tables?

```<!-- -->
```
-   How do we specify different behaviour for each type of object (one
is read only remember)

Well, the way I solved this was with single table inheritance.

Back to the Person class and throw this line in:

``` ruby
class Person < ActiveRecord::Base
  self.inheritance_column = 'class_name'
end
```

Now back into the console:

``` shell
baci:~/app mikel$ ./script/console
Loading development environment (Rails 2.0.2)
>> @person = Person.find(:first)
=> #<ExternalPerson id: 1, first_name: 'Mikel', last_name:
'Lindsaar' :class_name: 'ExternalPerson' .....
```

See now that it is an 'ExternalPerson' not a 'Person' class?

Further, we can do this:

``` shell
>> @p = Person.find(:first, :conditions => 'class_name = 'InternalPerson')
=> #<InternalPerson id: 1, first_name: 'Bob', last_name: 'Smith'
:class_name => 'ExternalPerson' .....
```

Notice that InternalPerson has the *same* ID. This can cause problems on
things like associations, which leads us to the next solution.

Say you want to have all people to be able to have an address, well,
normally you would just define an association in the Person class like
this:

``` ruby
class Person < ActiveRecord::Base
  has_one :address
end
```

But if you try that, it won't work, why? Because ExternalPerson and
InternalPerson present themselves as "Person" when asked for their class
inside of an association, this comes from a call to 'base_class' inside
the ActiveRecord associations.rb file.

This breaks things for us, because, while it would work for single table
inheritance, it will not work for multi-table inheritance. Luckily, we
can use some more rails goodness and ruby magic to make it work.

First, lets define the Address class to have a polymorphic association.
This means it can belong to more than one type of person.

``` ruby
class Address < ActiveRecord::Base
  belongs_to :person, :polymorphic => true
end
```

Now the migration:

``` ruby

class CreateAddressTable < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.column :street, :string
      t.column :suburb, :string
      t.column :post_code, :string
      t.column :person_id, :integer
      t.column :person_type, :string
    end
  end

  def self.down
    drop_table :addresses
  end
end
```

Not the person_id and person_type columns, these are the key part of the
polymorphic association, the person_id holds the id record of the person
and the type holds the class name of the person (in our case, either
ExternalPerson or InternalPerson).

Now, back to our person class, which now gets an association added and
looks like this:

``` ruby
class Person < ActiveRecord::Base
  self.inheritance_column = 'class_name'
  has_one :address, :as => :person
end
```

Now there is one more thing to do. If you left it like that, this would

*not* work. The reason is that as we are doing multiple table
inheritance, we have the possibility of ID conflict, that is, an ID in
the external_people table could be the same as the ID in the
internal_people table.

The associations right now in rails work by a class looking up it's
'base_class' and then using THAT class name as it's association class
name, confused? I was too.

I'll show you in the console (snipped for brevity)

``` shell
baci:~/app mikel$ ./script/console
Loading development environment (Rails 2.0.2)
>> @person = Person.find(:first)
=> #<ExternalPerson id: 1, first_name: 'Mikel', last_name: 'Lindsaar'
:class_name => 'ExternalPerson' .....
>> @person.class
=> ExternalPerson(id: integer, first_name: string...)
>> @person.base_class
=> Person
```

Now this is a problem when you are trying to do an inherited polymorphic
association out to the Address class. We want something like this in the
address table:

``` shell
ID    PersonId  PersonType         Street
1     1         ExternalPerson    123 somewhere
2     2         ExternalPerson    234 otherwhere
3     1         InternalPerson    456 anotherwhwere
4     3         ExternalPerson    789 sesamestreet
```

As we are doing multi-table inheritance, not single table inheritance.

As it stands now though, if we left it as is, the address table would
end up looking like this:

``` shell
ID    PersonId  PersonType         Street
1     1         Person            123 somewhere
2     2         Person            234 otherwhere
3     1         Person            456 anotherwhwere
4     3         Person            789 sesamestreet
```

Which will clearly cause problems due to the now non unique
PersonId/PersonType pairs. (Address ID 1 and ID 3 are the same person)

Turns out that how ActiveRecord works out what class to tell it's
associations it is, is by using a method called 'base_class'. In Ruby we
can override this like so:

``` ruby
class ExternalPerson < Person
  def self.base_class
    ExternalPerson
  end
end
```

and

``` ruby
class InternalPerson < Person
  def self.base_class
    InternalPerson
  end
end
```

And that is now it!

Now you can create your main associations using polymorphic associations
ONCE in your Person class keeping your code DRY, and then put any
specific over rides in the ExternalPerson and InternalPerson classes to
your hearts content.

Moreover, when you do a Person.find(:all, :limit =\> 10) you will get an
array of 10 objects which will either be ExternalPerson or
InternalPerson depending on which original table they came from, and as
they both are from 'Person' class, you can treat them like a person,
asking for their name or any other common method, pretty cool!

And you can also do "\@address.person" which will return you the correct
ExternalPerson or InternalPerson object all correctly instantiated...

So, off you go to enjoy some of your multi table inheritance goodness.

blogLater

Mikel
