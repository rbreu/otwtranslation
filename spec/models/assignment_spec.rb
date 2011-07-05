require 'spec_helper'

describe Otwtranslation::Assignment do

  before(:each) do
    @user1 = Factory.create(:user)
    @user2 =  Factory.create(:user)
    @user3 =  Factory.create(:user)
    @language = Factory.create(:language)
  end
  
  it "should create an assignment with parts" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1.login, @user2.login, @user3.login])
    Otwtranslation::AssignmentPart.all.size.should == 0
    assignment.save.should == true
    Otwtranslation::AssignmentPart.all.size.should == 3
    
    assignment.parts.size.should == 3
    assignment.parts.first.position.should == 1
    assignment.parts.first.user_id.should == @user1.id

    assignment.parts.last.position.should == 3
    assignment.parts.last.user_id.should == @user3.id
    assignment.parts.last.id.should_not == nil
  end

  it "should handle creation for non-existing user names" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1.login, "foo", @user3.login])
    assignment.errors[:parts].should == ["No such user: foo"]
    assignment.parts.size.should == 2
  end

  it "should create an assignment with source" do
    source = Factory.create(:source)
    assignment = Otwtranslation::Assignment.new(:source => source)
    assignment.source.should == source
    assignment.source_controller_action.should == source.controller_action
  end

  it "should return completed?=false for assignments with no parts" do
    assignment = Otwtranslation::Assignment.create()
    assignment.completed?.should == false
  end

  it "should return completed?=false" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1.login, @user2.login])
    assignment.save
    assignment.completed?.should == false
  end

  it "should return completed?=false" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1.login, @user2.login])
    assignment.save
    part = assignment.parts.first
    part.completed = true
    part.save
    
    assignment.completed?.should == false
  end

  it "should return completed?=true" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1.login, @user2.login])
    assignment.save
    part = assignment.parts.first
    part.completed = true
    part.save
    
    part = assignment.parts.last
    part.completed = true
    part.save
    
    assignment.completed?.should == true
  end

  it "should know assignees" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1.login, @user2.login, @user3.login])
    assignment.save
    assignment.assignees.should == [@user1, @user2, @user3]
  end

  it "should know assignees' names" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1.login, @user2.login, @user3.login])
    assignment.save
    assignment.assignees_names.should == [@user1.login, @user2.login,
                                          @user3.login].join(", ")
  end
end
