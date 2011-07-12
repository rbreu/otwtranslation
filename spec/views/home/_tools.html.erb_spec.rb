require 'spec_helper'
 	
describe "otwtranslation/home/_tools.html.erb" do
  it "should display the translation tabs" do
    view.stub(:logged_in?).and_return(false)
    render
    rendered.should contain 'languages'
    rendered.should contain 'sources'
    rendered.should contain 'phrases'
    rendered.should contain 'translation home'
    rendered.should have_selector("li", :count => 5)
  end

end
