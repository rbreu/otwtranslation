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

  
describe Otwtranslation::ContextRule, "apply_rules" do

  before(:each) do
    conditions = [["matches all", []]]
    @rule = Otwtranslation::ContextRule.new(:conditions => conditions)
  end
    
  
  it "should append" do
    @rule.actions = [["replace", {"append" => "Abby"}]]
    result = rule.apply_rules("This is {context||name} fic", :name => "Abby")
    result.should == "This is Abby's fic"
  end

end
