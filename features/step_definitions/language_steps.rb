Given /^I have the language "([^"]*)" with short "([^"]*)"$/ do |name, short|
  Factory(:language, {:name => name, :short => short})
end

Then /^I should see the language name "([^"]*)"$/ do |name|
  page.should have_selector('th.language, dd.language', :text => name)
end

Then /^I should see the language short "([^"]*)"$/ do |short|
  page.should have_selector('td.short, dd.short', :text => short)
end

Then /^I should see right to left set to "([^"]*)"$/ do |rtl|
  page.should have_selector('dd.direction', :text => rtl)
end

Then /^I should see translations visible set to "([^"]*)"$/ do |visible|
  page.should have_selector('dd.visible', :text => visible)
end


Given /^I (have selected|select) the language ([^"]*)$/ do |_, language|
  lang = Otwtranslation::Language.find_by_name(language) ||
    Factory(:language, {:name => language})
  
  visit "/"
  select language, :from => 'otwtranslation_language'
  click_button "Set language"
  
end
