Given /^I am a translator$/ do
  warn "Change translation admin to translator!"
  user = Factory.create(:user, {:translation_admin => true})
  visit "/"
  fill_in "User name", :with => user.login
  fill_in "Password", :with => user.password
  click_button "Log in"
  assert UserSession.find
end

