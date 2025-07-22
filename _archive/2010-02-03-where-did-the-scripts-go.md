---
title: "Where did the scripts go? "
author: Mikel Lindsaar
date: 2010-02-03
layout: home
redirect_from:
  - /2010/2/3/where-did-the-scripts-go
---
The recent
[commit](http://github.com/rails/rails/commit/d236827881d119fb9ad25c81ce8e7756f1966823)
removing the contents of the `script` directory streamlines rails
somewhat. But there were a lot of files in that directory, this is a
quick cheat sheet on what replaces what...

The script directory used to contain

  ------------------------- -- -------------------- -- ----------------------
  **Old Script File**          **How to use now**      **Shortcut Command**
  `about`                      rake about
  `server`                     rails server            rails s
  `console`                    rails console           rails c
  `dbconsole`                  rails dbconsole         rails db
  `generate`                   rails generate          rails g
  `destroy`                    rails destroy
  `performance/benchmark`      rails benchmark
  `performance/profiler`       rails profiler
  `plugin`                     rails plugin
  `runner`                     rails runner
  ------------------------- -- -------------------- -- ----------------------

As you can see from the above, the [server]{.underline},
[console]{.underline}, [dbconsole]{.underline} and
[generate]{.underline} parameters also have shortcut aliases.

When you run the `rails` command from within a Rails application
directory, the above commands work, however, if you run the `rails`
command from outside a Rails application directory, then the usual Rails
initialization command works in the format of
`rails/railties/bin/rails APP_PATH [options]`

Note with the new 3.0 rails command, the `APP_NAME` has been changed to
an `APP_PATH` and any options now come at the end, not before.
`APP_PATH` allows you to initialise a new Rails application at some
other path name and uses the last part of the path name for your
application.

One word of warning, if you are running the Rails 3.0 Beta using the
`--dev` flag from a clone of the Rails source tree, then be sure to call
`script/rails <command>` otherwise the rails binary that is run will be
from your system gems, and you will end up initialising a new Rails
application inside your new Rails 3 app directory.

blogLater

Mikel
