require 'spec_helper'

describe Otwtranslation::Assignment, "creation" do

  before(:each) do
    @user1 = FactoryGirl.create(:user)
    @user2 =  FactoryGirl.create(:user)
    @pseud3 =  FactoryGirl.create(:pseud)
    @language = FactoryGirl.create(:language)
  end
  
  it "should create an assignment with parts" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1.login, @user2, @pseud3])
    Otwtranslation::AssignmentPart.all.size.should == 0
    assignment.save!
    Otwtranslation::AssignmentPart.all.size.should == 3
    
    assignment.parts.size.should == 3
    assignment.parts[0].position.should == 1
    assignment.parts[0].user_id.should == @user1.id

    assignment.parts[1].position.should == 2
    assignment.parts[1].user_id.should == @user2.id

    assignment.parts[2].position.should == 3
    assignment.parts[2].user_id.should == @pseud3.user.id
  end

  it "should handle creation for non-existing user names" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1, "foo", @pseud3])
    assignment.errors[:parts].should == ["No user foo found."]
    assignment.parts.size.should == 2
  end

  it "should create an assignment with source" do
    source = FactoryGirl.create(:source)
    assignment = Otwtranslation::Assignment.new(:source => source)
    assignment.source.should == source
    assignment.source_controller_action.should == source.controller_action
  end
end

describe Otwtranslation::Assignment, "completed?" do

  before(:each) do
    @user1 = FactoryGirl.create(:user)
    @user2 =  FactoryGirl.create(:user)
    @language = FactoryGirl.create(:language)
  end
  
  it "should return false for assignments with no parts" do
    assignment = Otwtranslation::Assignment.create()
    assignment.completed?.should be_false
  end

  it "should return false" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1, @user2])
    assignment.save
    assignment.completed?.should be_false
  end

  it "should return false" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1, @user2])
    assignment.save
    part = assignment.parts.first
    part.status = :completed
    part.save
    
    assignment.completed?.should be_false
  end

  it "should return true" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1, @user2])
    assignment.save
    part = assignment.parts.first
    part.status = :completed
    part.save
    
    part = assignment.parts.last
    part.status = :completed
    part.save
    
    assignment.completed?.should be_true
  end
end


describe Otwtranslation::Assignment, "assignees" do

  before(:each) do
    @user1 = FactoryGirl.create(:user)
    @user2 =  FactoryGirl.create(:user)
    @user3 =  FactoryGirl.create(:user)
    @language = FactoryGirl.create(:language)
  end
  
  it "should know assignees" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1, @user2, @user3])
    assignment.save
    assignment.assignees.should == [@user1, @user2, @user3]
  end

  it "should know assignees' names" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1, @user2, @user3])
    assignment.save
    assignment.assignees_names.should == [@user1.login, @user2.login,
                                          @user3.login].join(", ")
  end


  it "should remove parts on assignment deletion" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1, @user2, @user3])
    assignment.save
    Otwtranslation::AssignmentPart.all.size.should == 3

    assignment.destroy
    Otwtranslation::AssignmentPart.all.size.should == 0
  end

  it "should handle reordering" do
    assignment = Otwtranslation::Assignment.new(:language => @language)
    assignment.set_assignees([@user1, @user2, @user3])
    assignment.save
    assignment.parts.first.move_lower
    assignment.reload
    assignment.parts.map {|p| p.assignee }.should == [@user2, @user1, @user3]
    assignment.assignees.should == [@user2, @user1, @user3]
  end
end


describe Otwtranslation::Assignment, "activated_assignments_for" do

  before(:each) do
    @user1 = FactoryGirl.create(:user)
    @user2 =  FactoryGirl.create(:user)
    @language1 = FactoryGirl.create(:language)
    @language2 = FactoryGirl.create(:language)
  end

  it "should find user's activated assignments" do
    assnm1 = FactoryGirl.create(:assignment, :language => @language1,
                                :activated => true)
    assnm1.set_assignees([@user1, @user2])
    assnm1.save!
    assnm2 = FactoryGirl.create(:assignment, :language => @language1,
                                :activated => true)
    assnm2.set_assignees([@user2, @user1])
    assnm2.save!

    a = Otwtranslation::Assignment.activated_for(@user1, @language1.short)
    a.should =~ [assnm1, assnm2]
  end
  
  it "shouldn't find not activated assignments" do
    assnm1 = FactoryGirl.create(:assignment, :language => @language1,
                                :activated => true)
    assnm1.set_assignees([@user1, @user2])
    assnm1.save!
    assnm2 = FactoryGirl.create(:assignment, :language => @language1,
                                :activated => false)
    assnm2.set_assignees([@user2, @user1])
    assnm2.save!

    a = Otwtranslation::Assignment.activated_for(@user1, @language1.short)
    a.should =~ [assnm1]
  end
  
  it "shouldn't find assignments for other languages" do
    assnm1 = FactoryGirl.create(:assignment, :language => @language1,
                                :activated => true)
    assnm1.set_assignees([@user1, @user2])
    assnm1.save!
    assnm2 = FactoryGirl.create(:assignment, :language => @language2,
                                :activated => true)
    assnm2.set_assignees([@user2, @user1])
    assnm2.save!

    a = Otwtranslation::Assignment.activated_for(@user1, @language1.short)
    a.should =~ [assnm1]
  end
  
  it "shouldn't find assignments for other users" do
    assnm1 = FactoryGirl.create(:assignment, :language => @language1,
                                :activated => true)
    assnm1.set_assignees([@user1, @user2])
    assnm1.save!
    assnm2 = FactoryGirl.create(:assignment, :language => @language1,
                                :activated => true)
    assnm2.set_assignees([@user2])
    assnm2.save!

    a = Otwtranslation::Assignment.activated_for(@user1, @language1.short)
    a.should =~ [assnm1]
  end
  
end


describe Otwtranslation::Assignment, "assignees_language_names" do

  before(:each) do
    @user1 = FactoryGirl.create(:user)
    @user2 =  FactoryGirl.create(:user)
    @language1 = FactoryGirl.create(:language)
    @language2 = FactoryGirl.create(:language)
  end

  it "should find user's languages" do
    assnm1 = FactoryGirl.create(:assignment, :language => @language1,
                                :activated => true)
    assnm1.set_assignees([@user1, @user2])
    assnm1.save!
    assnm2 = FactoryGirl.create(:assignment, :language => @language2,
                                :activated => true)
    assnm2.set_assignees([@user2, @user1])
    assnm2.save!

    l = Otwtranslation::Assignment.assignees_language_names(@user1)
    l.should =~ [@language1.name, @language2.name]
  end
  
  it "should not find user's languages when assnm not activated" do
    assnm1 = FactoryGirl.create(:assignment, :language => @language1,
                                :activated => true)
    assnm1.set_assignees([@user1, @user2])
    assnm1.save!
    assnm2 = FactoryGirl.create(:assignment, :language => @language2,
                                :activated => false)
    assnm2.set_assignees([@user2, @user1])
    assnm2.save!

    l = Otwtranslation::Assignment.assignees_language_names(@user1)
    l.should =~ [@language1.name]
  end

  it "shouldn't find other people's languages" do
    assnm1 = FactoryGirl.create(:assignment, :language => @language1,
                                :activated => true)
    assnm1.set_assignees([@user1, @user2])
    assnm1.save!
    assnm2 = FactoryGirl.create(:assignment, :language => @language2,
                                :activated => true)
    assnm2.set_assignees([@user2])
    assnm2.save!

    l = Otwtranslation::Assignment.assignees_language_names(@user1)
    l.should =~ [@language1.name]
  end
end


describe Otwtranslation::Assignment, "activate" do

  before(:each) do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @assignment = FactoryGirl.create(:assignment)
    @assignment.set_assignees([@user1, @user2])
    @assignment.save!
   
  end

  it "should not fail" do
    @assignment.activate
  end
  
  
  it "should activate, notify assignees and activate first part" do
    mail = mock
    mail.should_receive(:deliver).twice
    Otwtranslation::AssignmentMailer.should_receive(:assignment_notification).twice.and_return(mail)
    @assignment.activate
    @assignment.activated.should be_true
  end

  it "should not break when there are no assignees" do
    assignment = FactoryGirl.create(:assignment)
    expect{ assignment.activate }.not_to raise_error
  end
  
end

describe Otwtranslation::Assignment, "users_turn?" do

  before(:each) do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @user3 = FactoryGirl.create(:user)
    @assignment = FactoryGirl.create(:assignment, :activated => true)
    @assignment.set_assignees([@user1, @user2, @user3])
    p = @assignment.parts[0]
    p.status = :completed
    p.save!
    p = @assignment.parts[1]
    p.status = :active
    p.save!
  end

  it "should return false" do
    @assignment.users_turn?(@user1).should be_false
    @assignment.users_turn?(@user3).should be_false
  end

  it "should return true" do
    @assignment.users_turn?(@user2).should be_true
  end

  it "should return false if there is no active part" do
    assignment = FactoryGirl.create(:assignment, :activated => true)
    assignment.set_assignees([@user1, @user2, @user2])
    assignment.users_turn?(@user1).should be_false
    assignment.users_turn?(@user2).should be_false
    assignment.users_turn?(@user3).should be_false
  end

end
