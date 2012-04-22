Given /^I have the language "([^"]*)" with locale "([^"]*)"$/ do |name, locale|
  @language = FactoryGirl.create(:language, {:name => name, :locale => locale})
end

Then /^I should see the language name "([^"]*)"$/ do |name|
  page.should have_selector('th.language, dd.language', :text => name)
end

Then /^I should see the locale "([^"]*)"$/ do |locale|
  page.should have_selector('td.locale, dd.locale', :text => locale)
end

Then /^I should see right to left set to "([^"]*)"$/ do |rtl|
  page.should have_selector('dd.direction', :text => rtl)
end

Then /^I should see translations visible set to "([^"]*)"$/ do |visible|
  page.should have_selector('dd.visible', :text => visible)
end


Given /^I (have selected|select) the language ([^"]*)$/ do |_, language|
  @language = Otwtranslation::Language.find_by_name(language) ||
    FactoryGirl.create(:language, {:name => language})
  
  visit "/"
  select language, :from => 'otwtranslation_language'
  click_button "Set language"
  
end
