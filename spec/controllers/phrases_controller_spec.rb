require 'spec_helper'
 	
describe Otwtranslation::PhrasesController, "GET index" do

  it "should fail if we are not authenticated" do
    get :index
    response.should_not be_success
  end
  
  it "should return list of phrases" do
    admin_login()
    phrases = mock(Array)
    Otwtranslation::Phrase.should_receive(:paginate).and_return(phrases)
    get :index
    assigns[:phrases].should == phrases
  end
end

describe Otwtranslation::PhrasesController, "GET show" do
  
  it "should fail if we are not authenticated" do
    get :show, :id => "somekey"
    response.should_not be_success
  end
  
  it "should return a phrase" do
    admin_login()
    phrase = mock_model(Otwtranslation::Phrase)
    translations = mock(Array)
    translations.should_receive(:for_language)
    phrase.should_receive(:translations).and_return translations
    phrase.should_receive(:sources).and_return([])
    Otwtranslation::Phrase.should_receive(:find_by_key).with("somekey").and_return phrase

    get :show, :id => "somekey"
    assigns[:phrase].should == phrase
    assigns[:sources]
  end


end
