Given /^I am a user$/ do
end

Given /^I am a translator$/ do
  warn "Change translation admin to translator!"
  @user = FactoryGirl.create(:translation_admin)
  visit "/"
  fill_in "User name", :with => @user.login
  fill_in "Password", :with => @user.password
  click_button "Log in"
  assert UserSession.find
end

Given /^I am a translation admin$/ do
  user = FactoryGirl.create(:translation_admin)
  visit "/"
  fill_in "User name", :with => user.login
  fill_in "Password", :with => user.password
  click_button "Log in"
  assert UserSession.find
end

Given /^I'm on revision "([^"]*)"$/ do |version|
  OtwtranslationConfig.VERSION = version
end

Given /^I have the user "([^"]*)"$/ do |login|
  FactoryGirl.create(:user, :login => login)
end
