---
title: "'rbuf_fill': execution expired (Timeout::Error)"
author: Mikel Lindsaar
date: 2007-12-09
layout: home
redirect_from:
  - /2007/12/9/rbuf_filltimeout-error
---
This is a fun little exception in Ruby that you have to catch explicitly
in order to get hold of it in a rescue block.

Say you had the following:

``` ruby
require 'net/pop3'
begin
  Net::POP3.auth_only(@server, @port, @username, @password)
rescue => e
  write_error_to_logfile(e)
  do_something_sensible
end
```

And the mail server could not be reached due to transient network
problems -\> that is, you are getting a socket timeout error.

Well, your code in the rescue block `<strong>`{=html}won't get
executed!`</strong>`{=html} Even though the script raises an Error!

Why is this?

Simple answer, because Timeout::Error is not a subclass of
StandardError, it is a subclass of the Interrupt class.

So, that means you have to catch it explicitly, like so:

``` ruby
require 'net/pop3'
begin
  Net::POP3.auth_only(@server, @port, @username, @password)
rescue => e
  write_error_to_logfile(e)
  do_something_sensible
rescue Timeout::Error => e
  write_error_to_logfile(e)
  do_something_sensible_for_timeout
end
```

And all will be good again, error caught!

blogLater

Mikel
