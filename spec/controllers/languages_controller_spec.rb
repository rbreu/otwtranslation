require 'spec_helper'

describe Otwtranslation::LanguagesController, "GET index" do
  
  it "should fail if we are not authenticated" do
    get :index
    response.should_not be_success
  end

  it "should return list of languages" do
    admin_login()
    Language.should_receive(:all)
    get :index
  end
end

describe Otwtranslation::LanguagesController, "GET show" do
  
  it "should fail if we are not authenticated" do
    get :show, :id => 1
    response.should_not be_success
  end

  it "should return a language" do
    admin_login()
    Language.should_receive(:find_by_short).with(1)
    get :show, :id => 1
  end

end


describe Otwtranslation::LanguagesController, "GET new" do
  
  it "should fail if we are not authenticated" do
    get :new
    response.should_not be_success
  end

  it "should create a language" do
    admin_login()
    Language.should_receive(:create).with(1)
    get :new
  end

end
