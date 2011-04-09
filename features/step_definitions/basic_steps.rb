Given /^I am a user$/ do
end

Given /^I am a translator$/ do
  warn "Change translation admin to translator!"
  user = Factory(:translation_admin)
  visit "/"
  fill_in "User name", :with => user.login
  fill_in "Password", :with => user.password
  click_button "Log in"
  assert UserSession.find
end

Given /^I am a translation admin$/ do
  user = Factory(:translation_admin)
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
  Factory(:phrase, {:label => phrase})
end

Given /^I have the translation "([^"]*)" for "([^"]*)" in ([^"]*)$/ do |translation, phrase, language|
  lang = Otwtranslation::Language.find_by_name(language) ||
    Factory(:language, {:name => language})
  phrase = Otwtranslation::Phrase.find_by_label(phrase) ||
    Factory(:phrase, {:label => phrase})

  Factory(:translation, :label => translation,
          :language => lang, :phrase => phrase)
end

Given /^I have the approved translation "([^"]*)" for "([^"]*)" in ([^"]*)$/ do |translation, phrase, language|
  lang = Otwtranslation::Language.find_by_name(language) ||
    Factory(:language, {:name => language})
  phrase = Otwtranslation::Phrase.find_by_label(phrase) ||
    Factory(:phrase, {:label => phrase})

  Factory(:translation, :label => translation,
          :language => lang, :phrase => phrase, :approved => true)
end

Given /^I (have selected|select) the language ([^"]*)$/ do |_, language|
  lang = Otwtranslation::Language.find_by_name(language) ||
    Factory(:language, {:name => language})
  
  visit "/"
  select language, :from => 'otwtranslation_language'
  click_button "Set language"
  
end
