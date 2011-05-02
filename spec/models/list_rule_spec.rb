require 'spec_helper'

describe Otwtranslation::ListRule, "match" do
  
  it "should match has lesser/equal elements than rule" do
    conditions = [["has lesser/equal elements than", ["3"]]]
    rule = Otwtranslation::ListRule.new(:conditions => conditions)
    rule.match?([1]).should == true
    rule.match?([1, 2, 3]).should == true
    rule.match?([1, 2, 3, 4]).should == false
  end
    
  it "should match has number of elements rule" do
    conditions = [["has number of elements", ["3"]]]
    rule = Otwtranslation::ListRule.new(:conditions => conditions)
    rule.match?([1]).should == false
    rule.match?([1, 2, 3]).should == true
    rule.match?([1, 2, 3, 4]).should == false
  end
    
  it "should match has more elements than" do
    conditions = [["has more elements than", ["2"]]]
    rule = Otwtranslation::ListRule.new(:conditions => conditions)
    rule.match?([1]).should == false
    rule.match?([1, 2]).should == false
    rule.match?([1, 2, 3]).should == true
  end
end

