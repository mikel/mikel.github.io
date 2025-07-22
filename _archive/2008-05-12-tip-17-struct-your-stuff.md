---
title: "Tip #17 - Struct Your Stuff!"
author: Mikel Lindsaar
date: 2008-05-12
layout: home
redirect_from:
  - /2008/5/12/tip-17-struct-your-stuff
---
Ruby is a *really* dynamic language, and you can do a lot of cool
things, one of them is a Struct (Structure) that allows you to make
throw away objects that you can call methods on....

How do you use them? Simple!

``` ruby
Person = Struct.new(:name, :age, :job)
bob = Person.new("John", 21, "Postman")
bob.name #=> "John"
bob.age #=> 21
bob.job #=> "Postman"
```

"But wait!" you say, "That looks like a class!", well, it sort of is,
and you *could* do the same with:

``` ruby
class Person
  attr_accessor :name, :job, :age
end

bob = Person.new
bob.name = "John"
bob.age = 21
bob.job = "Postman"

bob.name #=> "John"
bob.age #=> 21
bob.job #=> "Postman"
```

But it is more work :)

What is a struct useful for? Well, turning a return array of arrays,
into a return array of objects. This is good if you are, say, parsing a
delimited file.

Say you had comma delimited file of people, you only needed to handle
this once to import the data into your real Ruby on Rails Person
ActiveRecord class, but you needed to do some work on the imported data
before you created the Person in the database permanently, this would be
perfect for a Struct.

Now, I am ignoring the CSV and FasterCSV libraries here, to keep things
simple.

Lets say the file looked like this:

``` sh
# PeopleFile.csv
BOB SMITH,21,FARMER,SYDNEY AUSTRALIA
JOHN JAMES,43,TECH,AUCKLAND NEW ZEALAND
SAM SMITHERS,99,TEACHER,BRISBANE AUSTRALIA
JESSIE JAMES,14,SCHOOL KID,ADELAIDE AUSTRALIA
```

Now, we can see that we have a list of people, the first field is the
first and last name, the second is the age, the third is the job title
and the last is the location.

Lets define a structure for this:

``` ruby
TempPerson = Struct.new(:first_name, :last_name, :age, :job, :city, :country)
```

Ok, good. Now, we go ahead and split the file up:

``` ruby
people = Array.new
File.read('PeopleFile.csv').each_line do |line|
  attrs = line.split(",")
  name = attrs[0].split(" ", 2)
  location = attrs[3].split(" ", 2)
  people << TempPerson.new(name[0],
                           name[1],
                           attrs[2],
                           attrs[3],
                           location[0],
                           location[1])
end
```

At the end of this, we have an array called people that is full of
TempPerson objects, each that can be accessed by #name, #age etc.

We could then get a list of all the countries by:

``` ruby
people.map { |p| p.country }
```

Which is a lot more readable than:

``` ruby
people.map { |p| p[3].split(" ", 2)[1] }
```

And do all sorts of other goodness with this fully fledged object!

Then when you are finally ready to save this into your database:

``` ruby
people.each do |p|
  Person.create(:first_name => p.first_name,
                :last_name  => p.last_name,
                :age        => p.age,
                :job        => p.job,
                :city       => p.city,
                :country    => p.country)
end
```

You can obviously do a lot more with Structs, this is just a start and I
like my tips to be short and sweet... anyone else got some good uses for
them?

blogLater

Mikel
