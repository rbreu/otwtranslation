require 'spec_helper'
 	
describe Otwtranslation::HomeController, "GET index" do
  it "should fail if we are not authenticated" do
    get :index
    response.should_not be_success
  end

  it "should be successful" do
    admin_login()
    get :index
    response.should be_success
  end

end


describe Otwtranslation::HomeController, "GET toggle_tools" do  
  before(:each) do
    request.env["HTTP_REFERER"] = "/"
  end

  it "should fail if we are not authenticated" do
    get :toggle_tools
    response.should_not be_success
  end

  context "when logged in as admin" do

    before(:each) do
      admin_login()
    end
  
    it "should enable translation tools" do
      session.delete(:otwtranslation_tools)
      get :toggle_tools
      session[:otwtranslation_tools].should equal true
    end

    it "should enable translation tools" do
      session[:otwtranslation_tools] = false
      get :toggle_tools
      session[:otwtranslation_tools].should equal true
    end

    it "should disable translation tools" do
      session[:otwtranslation_tools] = true
      get :toggle_tools
      session[:otwtranslation_tools].should equal false
    end
    
  end

end
