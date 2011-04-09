Given /^I have the language "([^"]*)" with short "([^"]*)"$/ do |name, short|
  Factory(:language, {:name => name, :short => short})
end

Then /^I should see the language name "([^"]*)"$/ do |name|
  Then "I should see \"#{name}\" within \"td.name, dd.name\""
end

Then /^I should see the language short "([^"]*)"$/ do |short|
  Then "I should see \"#{short}\" within \"td.short, dd.short\""
end

Then /^I should see right to left set to "([^"]*)"$/ do |rtl|
  Then "I should see \"#{rtl}\" within \"dd.right_to_left\""
end

Then /^I should see translations visible set to "([^"]*)"$/ do |visible|
  Then "I should see \"#{visible}\" within \"dd.translation_visible\""
end
