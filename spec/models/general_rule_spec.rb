require 'spec_helper'

describe Otwtranslation::GeneralRule, "creation" do
  it "should save" do
    conditions = [["matches all", []]]
    actions = [["replace", {:append => "Abby"}]]
    rule = Otwtranslation::GeneralRule.create(:conditions => conditions,
                                              :actions => actions,
                                              :language_short => "de",
                                              :description => "foo")
    rule.reload
    rule.language_short.should == "de"
    rule.description.should == "foo"
    rule.conditions.should == conditions
    rule.actions.should == actions
    rule.type.should == "Otwtranslation::GeneralRule"
  end

end

describe Otwtranslation::GeneralRule, "acts as list" do

  before(:each) do
    @rule1 = Otwtranslation::GeneralRule.create(:language_short => "de")
    @rule2 = Otwtranslation::GeneralRule.create(:language_short => "de")
  end
  
  it "should update position" do
    @rule1.position.should == 1
    @rule2.position.should == 2
  end

  it "should count from 1 for new language" do
    rule3 = Otwtranslation::GeneralRule.create(:language_short => "nl")
    rule3.position.should == 1
  end


  it "should count from 1 for new type" do
    rule3 = Otwtranslation::ListRule.create(:language_short => "de")
    rule3.position.should == 1
  end


  it "should move positions" do
    @rule2.move_higher
    @rule1.reload.position.should == 2
    @rule2.reload.position.should == 1
  end
  
end

  
