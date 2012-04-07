
Given /^I have the phrase "([^"]*)"$/ do |phrase|
  @phrase = FactoryGirl.create(:phrase, {:label => phrase})
end

Then /^I should see the phrase "([^"]*)"$/ do |label|
  page.should have_selector('th.label, dd.label', :text => label)
end

Then /^I should see the phrase source "([^"]*)"$/ do |source|
  page.should have_selector('dd.sources', :text => source)
end

Then /^I should see the phrase version "([^"]*)"$/ do |version|
  page.should have_selector('td.version, dd.version', :text => version)
end

