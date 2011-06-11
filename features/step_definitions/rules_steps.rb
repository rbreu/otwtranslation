Given /^I have the "([^"]*)" rule for the language "([^"]*)"$/ do |type, lang|
  type = "#{type}_rule".to_sym
  @language = Otwtranslation::Language.find_by_name(lang) || 
    Factory.create(:language, {:name => lang})
  @rule = Factory.create(type, {:language => @language})
end

Then /^I should see the rule type "([^"]*)"$/ do |type|
  page.should have_selector('td.type', :text => type)
end

Then /^I should see the rule description "([^"]*)"$/ do |description|
  page.should have_selector('td.description', :text => description)
end

Then /^I should see the rule condition "([^"]*)"$/ do |condition|
  page.should have_selector('td.conditions', :text => condition)
end

Then /^I should see the rule action "([^"]*)"$/ do |action|
  page.should have_selector('td.actions', :text => action)
end
