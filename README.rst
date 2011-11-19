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

  include OtwtranslationHelper
  helper :otwtranslation

to all of your mailers. (TODO: can we do this in one place?)

Add

::

  elsif params[:translation_id]
  @commentable = Otwtranslation::Translation.find(params[:translation_id])

to CommentsController.load_commentable

Add

::
  when /Translation/
  @name = "\"#{truncate(@commentable.label)}\""

to CommentsController.new

Add 

::
   if commentable.is_a?(Otwtranslation::Translation)
     commentable_id = :translation_id
     commentable_value = commentable.id
   else

to comments_helper:show_comments_link and hide_comments_link

Add

::

  <%= render :partial => 'layout/otwtranslation_includes' %>

to your application.html.erb

TODO: db migrations; stylesheets; javasripts


Usage
-----

The translation helper can be used like this::

  ts("Hello!")

To insert variables::

  ts("Hello {general::name}, you have {quantity::message}!",
      :name => "Alice", :message => 3)

You can also pass an additional description. Note that equal phrases
with different descriptions will result in two different translatable
phrases in the system, so only use if you are sure that's what you
want::

  ts("Hello!", :_description => "Front page greeting.")

To use the ts function in a place where no CSS markup for translators
can be used (e.g. button labels)::

  ts("Submit", :_decoration_off => true)

To specify a user whose language settings should be used instead of
current_user (useful for emails where the settings of the recipient
should be used)::

  ts("Hello!", :_user => some_user)


The t helper is currently just a dummy and is maintained for
transitioning reasons.

::

  t(".id", default => "Hello!")


Additional helpers: 

* ``otwtranslation_tool_toggler`` adds a link for translators and
  translation admins to toggle the translation tools

* ``otwtranslation_tool_header``: adds a toolbar for translators and
  translation admins when they have translation tools enabled

* ``otwtranslation_tool_source``: adds link to the current source for
  translators and translation admins when they have translation tools
  enabled


Notes
-----

Everything the Gem provides is properly namespaced, except for:

* The t and ts helpers
* A few extra columns that are added to the languages table
