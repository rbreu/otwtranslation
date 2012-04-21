require 'spec_helper'

describe Otwtranslation::Vote do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user2 =  FactoryGirl.create(:user)
    @translation = FactoryGirl.create(:translation)
  end
  
  it "should create a new vote" do
    vote = Otwtranslation::Vote.new()
    vote.owner = @user
    vote.translation = @translation
    vote.save!
  end

  it "should not create duplicate vote" do
    vote1 = Otwtranslation::Vote.new()
    vote1.owner = @user
    vote1.translation = @translation
    vote1.save!
    vote2 = Otwtranslation::Vote.new()
    vote2.owner = @user
    vote2.translation = @translation
    vote2.save.should be_false
  end

  it "should vote up" do
    Otwtranslation::Vote.vote(@translation, @user, :up)
    v = Otwtranslation::Vote.find_by_translation_id(@translation)
    v.votes.should == 1
  end

  it "shouldn't vote up twice" do
    Otwtranslation::Vote.vote(@translation, @user, :up)
    Otwtranslation::Vote.vote(@translation, @user, :up)
    Otwtranslation::Vote.all.size.should == 1
    v = Otwtranslation::Vote.find_by_translation_id(@translation)
    v.votes.should == 1
  end

  it "should vote down" do
    Otwtranslation::Vote.vote(@translation, @user, :down)
    v = Otwtranslation::Vote.find_by_translation_id(@translation)
    v.votes.should == -1
  end

  it "shouldn't vote down twice" do
    Otwtranslation::Vote.vote(@translation, @user, :down)
    Otwtranslation::Vote.vote(@translation, @user, :down)
    Otwtranslation::Vote.all.size.should == 1
    v = Otwtranslation::Vote.find_by_translation_id(@translation)
    v.votes.should == -1
  end

  it "should vote up and down without duplicating votes" do
    Otwtranslation::Vote.vote(@translation, @user, :up)
    Otwtranslation::Vote.vote(@translation, @user, :down)
    Otwtranslation::Vote.all.size.should == 1
    v = Otwtranslation::Vote.find_by_translation_id(@translation)
    v.votes.should == -1
  end
  
  it "should vote up for two different people" do
    Otwtranslation::Vote.vote(@translation, @user, :up)
    Otwtranslation::Vote.vote(@translation, @user2, :up)
    Otwtranslation::Vote.all.size.should == 2
  end
  
  it "should work with user ids" do
    Otwtranslation::Vote.vote(@translation, @user.id.to_s, :up)
    Otwtranslation::Vote.vote(@translation, @user2.id.to_s, :up)
    Otwtranslation::Vote.all.size.should == 2
  end
  
  it "should raise errors for unknown action" do
    expect { Otwtranslation::Vote.vote(@translation, @user, "foo") }
      .to raise_error(ArgumentError)
  end

  it "should calculate votes sums" do
    Otwtranslation::Vote.vote(@translation, @user, :up)
    @translation.votes.votes_sum.should == 1
  end

  it "should calculate votes sums" do
    Otwtranslation::Vote.vote(@translation, @user, :up)
    Otwtranslation::Vote.vote(@translation, @user2, :up)
    @translation.votes.votes_sum.should == 2
  end

  it "should calculate votes sums" do
    Otwtranslation::Vote.vote(@translation, @user, :up)
    Otwtranslation::Vote.vote(@translation, @user2, :down)
    @translation.votes.votes_sum.should == 0
  end

end
