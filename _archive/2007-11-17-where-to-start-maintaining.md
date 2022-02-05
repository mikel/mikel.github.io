---
title: "Where to start maintaining?"
author: Mikel Lindsaar
date: 2007-11-17
layout: post
redirect_from:
  - /2007/11/17/where-to-start-maintaining
---
As mentioned previously in the [TMail blog,](/tmail) I am now
maintaining the code base with another team member. But where to start?

The simple answer is:

#### 1. Scratch your own itch

and

#### 2. DOCUMENT THE DAMN THING!

Why?

Well, lets take TMail for example, the library is spread across 26 files
in the lib/tmail directory, has over 3000 test cases, two C files and to
top it of an RACC parser file.

If you don't know what RACC is, don't feel too bad, it is the YACC of
Ruby.

If you don't know what YACC is, it stands for Yet Another Compiler
Compiler and is a parsing language allowing you to parse text in a very
structured manner.

But I digress.

When I got the library into my little mits, the first thing I did was
get as many test cases working as possible, in my case, I got all but 2
REALLY edge case tests working immediately.

This was good enough for a basic understanding of the code.

Then I went ahead and "scratched my own itch" which is a phrase that
broadly means, fix what is bugging you in the code and get it working.
In my case, TMail was mangling the content-type header fields then the
multipart separator string contained an "=" symbol. Got this working
nicely.

Then, while I fixed the occasional bug report that came in via the
tracker I went to town on documenting the library.

I don't know about you, but when I pick up a library, I will use an
inferior library that just does the job if it's documentation is really
well written in preference to a library which has poor documentation. I
think this is a feeling shared by many and is probably due to the fact
that when you are using a library, you are trying to handle a specific
problem fast without having to code your own solution. So the last thing
you want to do is go digging through the library code trying to figure
out what the hell is going on!

So documenting is a key to a library's success.

Of course, the library has to do what it says it will do, but all other
things being equal, it is the documentation that makes or breaks the
success of a library.

So I am documenting TMail.

I'll keep you posted on what i ran into in documenting this library and
tips and hints on how to document.

blogLater

Mikel

