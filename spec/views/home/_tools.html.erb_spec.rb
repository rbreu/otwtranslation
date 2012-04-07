require 'spec_helper'
 	
describe "otwtranslation/home/_tools" do
  it "should display the translation tabs" do
    view.stub(:logged_in?).and_return(false)
    source = FactoryGirl.create(:source)
    view.should_receive(:source).any_number_of_times.and_return(source)
    render
    rendered.should contain 'languages'
    rendered.should contain 'sources'
    rendered.should contain 'phrases'
    rendered.should contain 'translation home'
    rendered.should contain 'assignments'
    rendered.should contain 'mails'
    rendered.should contain source.controller_action
    rendered.should have_selector("li", :count => 7)
  end

end
