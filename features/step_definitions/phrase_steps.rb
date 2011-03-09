Given /^I have the phrase "([^"]*)"$/ do |phrase|
  Otwtranslation::Phrase.find_or_create(phrase)
end
