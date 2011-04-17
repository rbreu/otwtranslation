require 'spec_helper'
 	
describe "otwtranslation/translations/_translation.html.erb" do

  context "approved translation" do

    before(:each) do
      translation = Factory(:translation, :approved => true)
      view.should_receive(:translation).any_number_of_times.and_return(translation)
    end
  
    it "should display correct buttons for approved translations" do
      render
      
      rendered.should have_selector('a', :content => 'Show')
      rendered.should have_selector('input', :value => 'Disapprove')
      rendered.should_not have_selector('input', :value => 'Edit')
      rendered.should_not have_selector('input', :value => 'Delete')
      rendered.should_not have_selector('input', :value => 'Approve')
    end

    it "should use 'approved' class" do
      render
      rendered.should have_selector('div', :class => 'translation approved')
    end
  end

  context "not approved translation" do

    before(:each) do
      translation = Factory(:translation, :approved => false)
      view.should_receive(:translation).any_number_of_times.and_return(translation)
    end
    
    it "should display correct buttons for not approved translations" do
      render
      
      rendered.should have_selector('a', :content => 'Show')
      rendered.should have_selector('input', :value => 'Approve')
      rendered.should have_selector('input', :value => 'Edit')
      rendered.should have_selector('input', :value => 'Delete')
      rendered.should_not have_selector('input', :value => 'Disapprove')
    end

    it "should not use 'approved' class" do
      render
      rendered.should_not have_selector('div', :class => 'approved')
    end
end
end
