Then /^I should see the comment "([^"]*)"$/ do |content|
  page.should have_selector('blockquote.userstuff', :text => content)
end
