Then /^I should see the rule type "([^"]*)"$/ do |type|
  page.should have_selector('.ruletype', :text => Regexp.new(type))
end

Then /^I should see the rule description "([^"]*)"$/ do |description|
  page.should have_selector('.userstuff.description', :text => description)
end

Then /^I should see the rule condition "([^"]*)"$/ do |condition|
  page.should have_selector('.rule-conditions li', :text => Regexp.new(condition))
end

Then /^I should see the rule action "([^"]*)"$/ do |action|
  page.should have_selector('.rule-actions', :text => action)
end

Given /^I have singular\/plural rules for ([^"]*)$/ do |language|
  @language = Otwtranslation::Language.find_by_name(language) ||
    FactoryGirl.create(:language, {:name => language})
  rule = Otwtranslation::QuantityRule.create(:conditions => [["is", ["1"]]],
                                             :locale => @language.locale)
  rule = Otwtranslation::QuantityRule.create(:conditions => [["matches all", []]],
                                             :locale => @language.locale)
end
