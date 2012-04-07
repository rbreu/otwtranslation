Given /^I have a translation with (\d+) comments$/ do |count|
  @translation = FactoryGirl.create(:translation)
  pseud =  User.current_user.default_pseud || FactoryGirl.create(:pseud)
  count.to_i.times do
    FactoryGirl.create(:comment,
                       {:commentable => @translation, :pseud => pseud})
  end
end

Then /^I should see the comment "([^"]*)"$/ do |content|
  page.should have_selector('blockquote.userstuff', :text => content)
end

Then /^I should see (\d+) comment blurbs$/ do |count|
  if count.to_i == 0
    page.should_not have_selector('li.comment')
  else
    page.should have_selector('li.comment', :count => count.to_i)
  end
end
