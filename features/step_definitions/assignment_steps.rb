Given /^I have an assignment for ([^"]*)$/ do |language|
  lang = Otwtranslation::Language.find_by_name(language) ||
    Factory(:language, {:name => language})
  @assignment = Factory.create(:assignment, :language => lang)
end

Given /^I have the assignees "([^"]*)"$/ do |logins|
  @assignment.parts = []
  Otwtranslation::ParameterParser.tokenize(logins).each do |login|
    user = User.find_by_login(login) || Factory.create(:user, {:login => login})
    Factory.create(:assignment_part, {:assignment => @assignment, :assignee => user} )
  end
end

Then /^I should see (\d+) assignments$/ do |count|
  if count.to_i == 0
    page.should_not have_selector('tr.assignment')
  else
    page.should have_selector('tr.assignment', :count => count.to_i)
  end
end

Then /^I should see the assignment description "([^"]*)"$/ do |description|
  page.should have_selector('dd.description', :text => description)
end

Then /^I should see the assignment source "([^"]*)"$/ do |source|
  page.should have_selector('dd.source', :text => source)
end

Then /^I should see the completed status "([^"]*)"$/ do |completed|
  page.should have_selector('dd.completed', :text => completed)
end

Then /^I should see the activated status "([^"]*)"$/ do |activated|
  page.should have_selector('dd.activated', :text => activated)
end

Then /^I should see the assignee "([^"]*)"$/ do |assignee|
  page.should have_selector('p.assignee', :text => assignee)
end

Then /^I should not see the assignee "([^"]*)"$/ do |assignee|
  page.should_not have_selector('p.assignee', :text => assignee)
end
