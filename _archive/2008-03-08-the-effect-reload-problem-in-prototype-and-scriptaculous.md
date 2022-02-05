---
title: "The effect reload problem in Prototype and Scriptaculous"
author: Mikel Lindsaar
date: 2008-03-08
layout: post
redirect_from:
  - /2008/3/8/the-effect-reload-problem-in-prototype-and-scriptaculous
  - /2008/3/7/the-effect-reload-problem-in-prototype-and-scriptaculous
---
This problem actually relates to any site that uses queued effects, I
just ran into it on Ruby on Rails. The problem is that if you queue up
too many scriptaculous effects on a dom object, you will end up having
nothing displayed, or flickering or highlights that never fade etc...

For Rails, getting your flash or message div to blind down, highlight
and blind up sounds easy enough, but if you are trying to do it with RJS
templages, you end up trying to sequence your calls with "page.delay(5)
do ... end" blocks to get it firing in the correct sequence... suffice
to say this smells/reeks of bad code smell.

So to handle this, I found the easiest way is to not use RJS templates
to display the flash effects directly, instead, you should wrap the
effects in a "show_flash" javascript function, which first deletes the
effects queue, resets the flash box to a known state and then runs the
effects again.

But enough talking, here is the code:

``` javascript
function show_flash(message) {
  // Get the queue for the box
  var queue = Effect.Queues.get('flashbox');
  // Reset each effect to start and cancel each one
  queue.each(function(e) {e.render(0); e.cancel()});
  // Reset the background to the initial (white) value
  $('FlashBox').setStyle({backgroundColor: '#FFFFFF'});
  // Update the contents of the box (which should now be hidden
  $('FlashBox').update(message);
  // Add each effect you want back into the queue
  new Effect.BlindDown('FlashBox', {
    duration: 1,
    queue: { scope: 'flashbox',
             position: 'front' }
  });
  new Effect.Highlight('FlashBox', {
    duration: 5,
    queue: { scope: 'flashbox',
             position: 'end' }
  });
  new Effect.SlideUp('FlashBox', {
    duration: 3,
    queue: { scope: 'flashbox',
             position: 'end' }
  });
}
```

Put that into your application.js file if you are using Rails.

This function can now be called from your RJS template like this:

``` ruby
page << %[show_flash('flash_message_text')]
```

Now you can call this as often as you want and your flash will always
nicely blind down, highlight and slide up! If it gets interrupted in the
middle of the effect, it will reset the effect to nothing (hide the box,
reset the background) and reset the message and then start again.

One gotcha is that you need to make sure that the variable
flash_message_text does not contain any single quotes, you can use
double quotes instead. If you do need to use single quotes, then escape
them so Javascript does not interpret them as the end of the string.

This is where I found out about the [effect
queue](http://wiki.script.aculo.us/scriptaculous/show/EffectQueues)

Shout out to bugrain for the pointers.

blogLater

Mikel

