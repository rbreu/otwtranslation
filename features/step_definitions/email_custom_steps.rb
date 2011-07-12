Then /^"([^\"]*)" should get (\d+) mails?$/ do |user, count|
  @user = User.find_by_login(user)
  emails("to: \"#{email_for(@user.email)}\"").size.should == count.to_i
end
