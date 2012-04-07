require 'spec_helper'
 	
describe "otwtranslation/assignments/_navigation" do
  
  before(:each) do
    @assignment = FactoryGirl.create(:assignment)
    @user = FactoryGirl.create(:user)
    view.should_receive(:assignment).any_number_of_times.and_return(@assignment)
    view.should_receive(:current_user).any_number_of_times.and_return(@user)
  end

  it "should display all buttons for unactivated assignment on show" do
    view.should_receive(:on_show).any_number_of_times.and_return(true)
    render

    rendered.should have_selector('input', :value => 'Edit')
    rendered.should have_selector('input', :value => 'Delete')
    rendered.should have_selector('input', :value => 'Activate')
    rendered.should have_selector('input', :value => 'Add assignee')
    rendered.should_not have_selector('input', :value => 'Show')
  end

  it "should display all buttons for unactivated assignment on index" do
    view.should_receive(:on_show).any_number_of_times.and_return(false)
    render

    rendered.should have_selector('input', :value => 'Edit')
    rendered.should have_selector('input', :value => 'Delete')
    rendered.should have_selector('input', :value => 'Activate')
    rendered.should have_selector('input', :value => 'Add assignee')
    rendered.should have_selector('input', :value => 'Show')
  end

  it "should not display edit buttons for activated assignments" do
    @assignment.activate
    view.should_receive(:on_show).any_number_of_times.and_return(true)
    render

    rendered.should_not have_selector('input', :value => 'Edit')
    rendered.should have_selector('input', :value => 'Delete')
    rendered.should_not have_selector('input', :value => 'Activate')
    rendered.should_not have_selector('input', :value => 'Add assignee')
    rendered.should_not have_selector('input', :value => 'Mark my part as completed')
  end

  it "should not display 'Mark my part as completed' when it's the current user's turn" do
    @assignment.set_assignees([@user])
    @assignment.save!
    @assignment.activate
    view.should_receive(:on_show).any_number_of_times.and_return(true)
    render

    rendered.should have_selector('input', :value => 'Mark my part as completed')
  end

  
end
