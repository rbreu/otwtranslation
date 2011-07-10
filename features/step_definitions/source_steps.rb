Then /^I should see the source action "([^"]*)"$/ do |action|
  page.should have_selector('td.controller_action, dd.action', :text => action)
end

Then /^I should see the source url "([^"]*)"$/ do |url|
  page.should have_selector('td.url, dd.url', :text => url)
end

Then /^I should see phrase with current version "([^"]*)"$/ do |version|
  page.should have_selector('td.version, dd.version', :text => version)
end

Given /^I have the source "([^"]*)"$/ do |source|
  @source = Factory.create(:source, :controller_action => source)
end
