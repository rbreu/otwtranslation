Given /^I have the (approved |)translation "([^"]*)" for "([^"]*)" in ([^"]*)$/ do |approved, translation, label, language|
  lang = Otwtranslation::Language.find_by_name(language) ||
    Factory(:language, {:name => language})
  @phrase = Otwtranslation::Phrase.find_by_label(label) ||
    Factory(:phrase, {:label => label})

  approved = !approved.blank?
  Factory(:translation, :label => translation,
          :language => lang, :phrase => @phrase, :approved => approved)
end


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

Then /^I should see the translation "([^"]*)"$/ do |translation|
  page.should have_selector('p.label', :text => translation)
end

Then /^I should not see the translation "([^"]*)"$/ do |translation|
  page.should_not have_selector('p.label', :text => translation)
end

Then /^I should see approved set to "([^"]*)"$/ do |approved|
  page.should have_selector('dd.approved', :text => approved)
end

