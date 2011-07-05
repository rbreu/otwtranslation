Given /^I have an assignment for ([^"]*)$/ do |language|
  lang = Otwtranslation::Language.find_by_name(language) ||
    Factory(:language, {:name => language})
  Factory.create(:assignment, :language => lang)
end

Then /^I should see (\d+) assignments$/ do |count|
  if count.to_i == 0
    page.should_not have_selector('tr.assignment')
  else
    page.should have_selector('tr.assignment', :count => count.to_i)
  end
end
