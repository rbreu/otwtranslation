require 'spec_helper'

describe Otwtranslation::Assignment do

  before(:each) do
    @user1 = Factory.create(:user)
    @user2 =  Factory.create(:user)
    @user3 =  Factory.create(:user)
  end
  
  it "should create an assignment with parts" do
    assignment = Otwtranslation::Assignment.create([@user1.login, @user2.login,
                                                    @user3.login])
    assignment.parts.size.should == 3
    assignment.parts.first.position.should == 1
    assignment.parts.first.user_id.should == @user1.id
    assignment.parts.last.position.should == 3
    assignment.parts.last.user_id.should == @user3.id
  end

  it "should handle creation for non-existing user names" do
    assignment = Otwtranslation::Assignment.create([@user1.login, "foo",
                                                    @user3.login])
    assignment.errors[:parts].should == ["No such user: foo"]
    assignment.parts.size.should == 2
  end

  it "should return completed=false" do
    assignment = Otwtranslation::Assignment.create([@user1.login, @user2.login])
    assignment.completed == false
  end

  it "should return completed=false" do
    assignment = Otwtranslation::Assignment.create([@user1.login, @user2.login])
    part = assignment.parts.first
    part.completed = true
    part.save
    
    assignment.completed == false
  end

  it "should return completed=true" do
    assignment = Otwtranslation::Assignment.create([@user1.login, @user2.login])
    part = assignment.parts.first
    part.completed = true
    part.save
    
    part = assignment.parts.last
    part.completed = true
    part.save
    
    assignment.completed == true
  end

end
