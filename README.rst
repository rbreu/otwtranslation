Translation engine for OTWArchive
=================================


This Gem provides the translation engine for the OTWArchive
software. It is heavily based on the Tr8n plugin by Michael Berkovich.


Installation
------------

Add

::

  gem otwtranslation

to your gemfile.



Usage
-----

The translation helper can be used like this::

  ts("Hello!")

You can also pass an additional description. Note that equal phrases
with different descriptions will result in two different translatable
phrases in the system

::

  ts("Hello!", "Front page greeting.")

The t helper is currently just a dummy and is maintained for
transitioning reasons.

::

  t(".id", default => "Hello!")


