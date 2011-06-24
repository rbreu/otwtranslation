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

Given /^I have singular\/plural rules for ([^"]*)$/ do |language|
  @language = Otwtranslation::Language.find_by_name(language) ||
    Factory(:language, {:name => language})
  rule = Otwtranslation::QuantityRule.create(:conditions => [["is", ["1"]]],
                                             :language_short => @language.short)
  rule = Otwtranslation::QuantityRule.create(:conditions => [["matches all", []]],
                                             :language_short => @language.short)
end
