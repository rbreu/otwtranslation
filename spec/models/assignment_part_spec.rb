require 'spec_helper'

describe Otwtranslation::AssignmentPart, "status" do

  before(:each) do
    assignment = Factory.create(:assignment)
    user = Factory.create(:user)
    @part = part = Otwtranslation::AssignmentPart.new(:assignment => assignment,
                                                      :assignee => user)
  end

  it "should create default status of :pending" do
    @part.status.should == :pending
    @part.save.should == true
  end
  
  it "should accept status :active" do
    @part.status = :active
    @part.save.should == true
    @part.status.should == :active
  end
  
  it "should accept status :completed" do
    @part.status = :completed
    @part.save.should == true
    @part.status.should == :completed
  end
  
  it "should raise error for unknown status" do
    expect{ @part.status = :foo }.to raise_error(ArgumentError)
  end
end


describe Otwtranslation::AssignmentPart, "activate" do

  it "should not fail" do
    part = Factory.create(:assignment_part)
    part.activate
  end

  it "should activate and send mail" do
    part = Factory.create(:assignment_part)
    mail = mock
    mail.should_receive(:deliver)
    Otwtranslation::AssignmentMailer.should_receive(:assignment_part_notification).and_return(mail)
    part.activate
    part.status.should == :active
  end
end
