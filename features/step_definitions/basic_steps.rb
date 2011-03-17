Given /^I am a user$/ do
end

Given /^I am a translator$/ do
  warn "Change translation admin to translator!"
  user = Factory.create(:translation_admin)
  visit "/"
  fill_in "User name", :with => user.login
  fill_in "Password", :with => user.password
  click_button "Log in"
  assert UserSession.find
end

Given /^I am a translation admin$/ do
  user = Factory.create(:translation_admin)
  visit "/"
  fill_in "User name", :with => user.login
  fill_in "Password", :with => user.password
  click_button "Log in"
  assert UserSession.find
end

Given /^I'm on revision "([^"]*)"$/ do |version|
  OtwtranslationConfig.VERSION = version
end

Given /^I have the phrase "([^"]*)"$/ do |phrase|
  Factory.create(:phrase, {:label => phrase})
end

Given /^I have the language ([^"]*)$/ do |language|
  Factory.create(:language, {:name => language})
end

Given /^I have the translation "([^"]*)" for "([^"]*)" in ([^"]*)$/ do |translation, phrase, language|
  pending 
end

Given /^I have selected the language ([^"]*)$/ do |language|
  pending 
end
