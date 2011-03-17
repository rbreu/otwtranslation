require 'spec_helper'
 	
describe Otwtranslation::PhrasesController, "GET index" do

  it "should fail if we are not authenticated" do
    get :index
    response.should_not be_success
  end
  
  it "should return list of phrases" do
    admin_login()
    phrases = mock(Array)
    Otwtranslation::Phrase.should_receive(:all).and_return(phrases)
    get :index
    assigns[:phrases] = phrases
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
    Otwtranslation::Phrase.should_receive(:find_by_key).with("somekey").and_return phrase
    get :show, :id => "somekey"
    assigns[:phrase] = phrase
  end

  def translations_for(language)
    translations.where(:language_id => language)
  end
  

end
