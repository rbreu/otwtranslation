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

Add 

::

  include OtwtranslationHelper

to your ``application_controller.rb`` to access the helpers from
within your views and controllers.

Add

::

  <%= render :partial => 'layout/otwtranslation_includes' %>

to your application.html.erb

TODO: db migrations; stylesheets; javasripts


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


Additional helpers: 

* ``otwtranslation_tool_toggler`` adds a link for translators and
  translation admins to toggle the translation tools

* ``otwtranslation_tool_header``: adds a toolbar for translators and
  translation admins when they have translation tools enabled


Notes
-----

Everything the Gem provides is properly namespaced, except for:

* The t and ts helpers
* A few extra columns that are added to the languages table
