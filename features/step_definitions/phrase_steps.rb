Then /^I should see the phrase "([^"]*)"$/ do |phrase|
  Then "I should see \"#{phrase}\" within \"td.label, dd.label\""
end

Then /^I should see the phrase source "([^"]*)"$/ do |source|
  Then "I should see \"#{source}\" within \"dd.sources\""
end

Then /^I should see the phrase version "([^"]*)"$/ do |version|
  Then "I should see \"#{version}\" within \"dd.version\""
end

