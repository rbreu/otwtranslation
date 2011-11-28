Given /^I have the (approved |)translation "([^"]*)" for "([^"]*)" in ([^"]*)$/ do |approved, translation, label, language|
  lang = Otwtranslation::Language.find_by_name(language) ||
    Factory(:language, {:name => language})
  @phrase = Otwtranslation::Phrase.find_by_label(label) ||
    Factory(:phrase, {:label => label})

  approved = !approved.blank?
  @translation = Factory(:translation, :label => translation,
                         :language => lang, :phrase => @phrase,
                         :approved => approved)
end


Then /^I should see the translation toolbar$/ do
  page.should have_selector('#header ul.translation.navigation')
end

Then /^I should not see the translation toolbar$/ do
  page.should_not have_selector('#header ul.otwtranslation[role="navigation"]')
end

Then /^I should see marked phrases$/ do
  page.should have_selector('span.translated, span.approved, span.untranslated')
end


Then /^I should not see marked phrases$/ do
  page.should_not have_selector('span.translated, span.approved, span.untranslated')
end

Then /^I should see the translation "([^"]*)"$/ do |translation|
  page.should have_selector('p.label', :text => translation)
end

Then /^I should not see the translation "([^"]*)"$/ do |translation|
  page.should_not have_selector('p.label', :text => translation)
end

Then /^I should see that the translation is edited by me$/ do
  "I should see \"#{User.current_user.login}\" within \"p.datetime\""
end

Then /^I should see the votes "([^"]*)"$/ do |votes|
  page.should have_selector('dd.votes', :text => votes)
end

Then /^I should see the comments "([^"]*)"$/ do |comments|
  page.should have_selector('dd.comments', :text => comments)
end

Then /^I should see (\d+) translations$/ do |count|
  page.should have_selector('p.label', :count => count.to_i)
end

Then /^I should see the translation rule "([^"]*)"$/ do |rule|
  page.should have_selector('div.rules', :text => rule)
end

Then /^I should see approved set to "([^"]*)"$/ do |approved|
  begin
    page.should have_selector('dd.approved', :text => approved)
  rescue Selenium::WebDriver::Error::ObsoleteElementError
    # ajax call took to long to finish, try again
    sleep 1
    page.should have_selector('dd.approved', :text => approved)
  end
end

When /^I right\-click on the hello world phrase$/ do
  key = Otwtranslation::Phrase.find_by_label("Hello World!").key
  #puts page.driver.browser.methods
  #page.driver.mouse_down_right('span#otwtranslation_phrase_#{key}')
  #mouse_up_right('span#otwtranslation_phrase_#{key}')
  #find_element(:name, 'test')
  #puts page.driver.browser.class
  #puts page.driver.browser.methods
  #puts page.driver.browser.instance_variables

  #puts page.class
  #puts page.methods
  #puts page.instance_variables
  
  page.evaluate_script("""
    var element = $('span#otwtranslation_phrase_#{key}')
    var evt = element.ownerDocument.createEvent('MouseEvents');

    evt.initMouseEvent('click', true, true,
      element.ownerDocument.defaultView, 1, 0, 0, 0, 0, false,
      false, false, false, RIGHT_CLICK_BUTTON_CODE, null);

    if (document.createEventObject){
        // dispatch for IE
        return element.fireEvent('onclick', evt)
    }
    else{
        // dispatch for firefox + others
        return !element.dispatchEvent(evt);
    }

 """)
end

Then /^I should see the inline translator$/ do
  page.should have_selector('div.show.inline')
end

