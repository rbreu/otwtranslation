require 'spec_helper'
 	
describe Otwtranslation::PhrasesController, "GET index" do

  it "should fail if we are not authenticated" do
    get :index
    response.should_not be_success
  end
  
  it "should return list of phrases" do
    admin_login()
    Otwtranslation::Phrase.should_receive(:all)
    get :index
  end
end

describe Otwtranslation::PhrasesController, "GET show" do
  
  it "should fail if we are not authenticated" do
    get :show, :id => "somekey"
    response.should_not be_success
  end
  
  it "should return a phrase" do
    admin_login()
    Otwtranslation::Phrase.should_receive(:find_by_key).with("somekey")
    get :show, :id => "somekey"
  end
end
