require 'spec_helper'

describe Otwtranslation::ContextRule, "match" do
  
  it "should not match empty condition" do
    conditions = []
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?("Abby").should == false
  end

  it "should match matches all condition" do
    conditions = [["matches all", []]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?("Abby").should == true
  end

  it "should match single is not rule" do
    conditions = [["is not", ["100"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?("101").should == true
  end

  it "should match single is rule with list param" do
    conditions = [["is", ["foo", "bar"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?("foo").should == true
    rule.match?("bar").should == true
    rule.match?("baz").should == false
  end

  it "should match double ends with/starts with rule" do
    conditions = [["ends with", ["x", "s"]], ["starts with", ["A", "a"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    
    rule.match?("Abby").should == false
    rule.match?("Andreas").should == true
    rule.match?("Alex").should == true
                  
    rule.match?("abby").should == false
    rule.match?("andreas").should == true
    rule.match?("alex").should == true
                  
    rule.match?("Bobby").should == false
    rule.match?("Boss").should == false
    rule.match?("Linux").should == false
  end

  it "should match does not end with rule" do
    conditions = [["does not end with", ["x", "s"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?("Abby").should == true
    rule.match?("Andreas").should == false
    rule.match?("Alex").should == false
  end
    
  it "should match does not start with rule" do
    conditions = [["does not start with", ["A", "a"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?("Abby").should == false
    rule.match?("alex").should == false
    rule.match?("bob").should == true
  end
    
  it "should match lesser/equal than" do
    conditions = [["is lesser/equal than", ["2"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?(1).should == true
    rule.match?(2).should == true
    rule.match?(3).should == false
  end
    
  it "should match greater than" do
    conditions = [["is greater than", ["2"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?(1).should == false
    rule.match?(2).should == false
    rule.match?(3).should == true
  end    
end


describe Otwtranslation::ContextRule, "perform_actions" do
  
  it "should handle no actions" do
    actions = []
    rule = Otwtranslation::ContextRule.new(:actions => actions)
    rule.perform_actions("name", "Abby").should == "Abby"
  end

  it "should apply replace rule" do
    actions = [["replace", {:replacement => "Alice"}]]
    rule = Otwtranslation::ContextRule.new(:actions => actions)
    rule.perform_actions("name", "Abby").should == "Alice"
  end

  it "should apply append rule" do
    actions = [["append", {:suffix => "'s"}]]
    rule = Otwtranslation::ContextRule.new(:actions => actions)
    rule.perform_actions("name", "Abby").should == "Abby's"
  end

  it "should apply prepend rule" do
    actions = [["prepend", {:prefix => "d'"}]]
    rule = Otwtranslation::ContextRule.new(:actions => actions)
    rule.perform_actions("name", "Abby").should == "d'Abby"
  end

  it "should auto pluralize" do
    actions = [["auto pluralize", {}]]
    rule = Otwtranslation::ContextRule.new(:actions => actions)
    rule.perform_actions("message", 1).should == "1 message"
    rule.perform_actions("message", 2).should == "2 messages"
  end

  it "should handle two actions" do
    actions = [["append", {:suffix => "'s"}], ["prepend", {:prefix => "of "}]]
    rule = Otwtranslation::ContextRule.new(:actions => actions)
    rule.perform_actions("name", "Abby").should == "of Abby's"
  end

end
  
describe Otwtranslation::ContextRule, "apply_rules" do

  before(:each) do
    conditions = [["matches all", []]]
    @rule = Otwtranslation::GeneralRule.new(:conditions => conditions,
                                            :language_short => "en")
  end
    
  
  it "should handle one rule with no variables" do
    result = Otwtranslation::ContextRule.
      apply_rules("This is {general::name} fic", "en")
    result.should == "This is {general::name} fic"
  end

  it "should handle one rule with set variables" do
    @rule.actions = [["append", {:suffix => "'s"}]]
    @rule.save
    result = Otwtranslation::ContextRule.
      apply_rules("This is {general::name} fic", "en", :name => "Abby")
    result.should == "This is Abby's fic"
  end

  it "should handle two rules with set variables" do
    @rule.actions = [["append", {:suffix => "'s"}]]
    @rule.save
    result = Otwtranslation::ContextRule.
      apply_rules("This is {general::author} fic and {general::artist} art.",
                  "en", :author => "Abby", :artist => "Becky")
    result.should == "This is Abby's fic and Becky's art."
  end

end


describe Otwtranslation::ContextRule, "acts as list" do

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


  it "should move positions" do
    @rule2.move_higher
    @rule1.reload.position.should == 2
    @rule2.reload.position.should == 1
  end
  
end
