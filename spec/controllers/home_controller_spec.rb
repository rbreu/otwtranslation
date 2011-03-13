require 'spec_helper'
 	
describe Otwtranslation::HomeController, "GET index" do
end


describe Otwtranslation::HomeController, "GET toggle_tools" do
  before(:each) do
    request.env["HTTP_REFERER"] = "/"
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
