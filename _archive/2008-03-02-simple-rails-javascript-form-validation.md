---
title: "Simple Rails Javascript Form Validation"
author: Mikel Lindsaar
date: 2008-03-02
layout: post
redirect_from:
  - /2008/3/2/simple-rails-javascript-form-validation
---
If you have a form with some required text fields (like, name, password)
then waiting for your users to hit submit is too late to tell them those
fields are required. The other option is disabling the submit button
until they have filled in the data, here is how...

First, you need to have the javascript default libraries loaded in Rails
to make this work.

Once you have done that, then open up your
public/javascripts/application.js and enter the following:

``` javascript
document.observe('form:button_disable', function (event) {
  // Find the button that we want to disable
  var button = $('ButtonDomID');
  // Disable it!
  button.disabled = true;

  // Find the field that is required:
  var required_field = $('FieldDomID');

  // Set up an observer to monitor this field
  new Field.Observer(required_field, 0.3, function() {
    // If field == '' then button disabled = true
    button.disabled = ($F(required_field) === '');
    });
});
```

And that's it!

You should also put a little note at the bottom under your submit button
that says it won't work until you enter something.

You can put whatever logic you want into the Field.Observer, for
example, replace the button.disabled = line with the following and it
will check to see it has a minimum length as well:

``` javascript
length_ok = ($F(required_field).length >= 10);
not_empty = ($F(required_field).value !== '');
button.disabled = !(length_ok && not_empty);
```

blogLater

Mikel

