Given /^I'm on revision "([^"]*)"$/ do |version|
  OtwtranslationConfig.VERSION = version
end

Given /^I have the phrase "([^"]*)"$/ do |phrase|
  Otwtranslation::Phrase.find_or_create(phrase)
end

Given /^I have the language ([^"]*)$/ do |language|
  Factory.create(:language,
                 {:name => language, :short => language[0,2].downcase})
end
