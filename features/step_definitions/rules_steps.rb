Given /^I have the "([^"]*)" rule for the language "([^"]*)"$/ do |type, lang|
  type = "#{type}_rule".to_sym
  @language = Otwtranslation::Language.find_by_name(lang) || 
    Factory.create(:language, {:name => lang})
  @rule = Factory.create(type, {:language => @language})
end
