require 'spec_helper'

describe Otwtranslation::SourcesController, "GET index" do
  
  it "should fail if we are not authenticated" do
    get :index
    response.should_not be_success
  end

  it "should return list of sources" do
    admin_login()
    Otwtranslation::Source.should_receive(:all)
    get :index
  end
end

describe Otwtranslation::SourcesController, "GET show" do
  
  it "should fail if we are not authenticated" do
    get :show, :id => 1
    response.should_not be_success
  end

  it "should return a source" do
    admin_login()
    Otwtranslation::Source.should_receive(:find).with(1)
    get :show, :id => 1
  end
end
