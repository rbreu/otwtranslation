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


As of version 0.0.1, the gem only provides to dummy helper methods::

  ts("Hello!")
  t(".id", default => "Hello!")

Note that the t method is deprecated.
