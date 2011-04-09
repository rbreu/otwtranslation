Then /^I should see the translation toolbar$/ do
  page.should have_selector('#header ul.otwtranslation[role="navigation"]')
end

Then /^I should not see the translation toolbar$/ do
  page.should_not have_selector('#header ul.otwtranslation[role="navigation"]')
end


Then /^I should see marked phrases$/ do
  page.should have_selector('span.otwtranslation_mark_translated, span.otwtranslation_mark_approved, span.otwtranslation_mark_untranslated')
end


Then /^I should not see marked phrases$/ do
  page.should_not have_selector('span.otwtranslation_mark_translated, span.otwtranslation_mark_approved, span.otwtranslation_mark_untranslated')
end
