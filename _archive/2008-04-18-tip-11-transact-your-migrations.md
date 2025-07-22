---
title: "Tip #11 - Transact Your Migrations!"
author: Mikel Lindsaar
date: 2008-04-18
layout: home
redirect_from:
  - /2008/4/18/tip-11-transact-your-migrations
  - /2008/4/17/tip-11-transact-your-migrations
---
If you are using Rails, you are most likely using migrations. Have you
ever had a migration fail half way through? Have you ever then had to
figure out how to find each change and revert it in the database? Would
you like to **never** have to do that again? Here is how...

#### USE TRANSACTIONS

I sometimes wonder why this just isn't the default. When I am doing a
migration, I either want the thing to work completely **all** the way
through, or I want **nothing** done to the database.

Luckily, you can do this with transactions.

A transaction (for those non SQL people out there) is an idea of a
series of events being atomic. That is, either, they all are executed
without error, or if any one of them fails or faults, then no change is
made to the database at all.

Luckily, adding transactions to a migration is very easy.

``` ruby
class ComplexMigrationThatCanNotFail < ActiveRecord::Migration

  def self.up
    transaction do
      add_column :table, :name, :type
      add_column :table, :name, :type
      # Complex task #1
      remove_column :table, :name, :type
      remove_column :table, :name, :type
      # Complex task #2
    end
  end

  def self.down
    # ... Down script
  end

end
```

Now, say your migration fails at the second remove column, no fear,
everything is rolled back to the start point, you can read the rake
error messages, fix the problem, and try again.

Of course, you are testing this on the development server, so no major
harm done if it blows up a couple of times, but I don't know about you,
but I have lots more things to do than try to restore two gigabytes of
staging or development database :)

blogLater

Mikel
