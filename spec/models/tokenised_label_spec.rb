require 'spec_helper'

describe Otwtranslation::TokenisedLabel do

  it "should parse phrase with one rule" do
    tl = Otwtranslation::TokenisedLabel.new("Hello {data::name}!")
    tl.label.should == [[:text, "Hello "],
                        [:rule, {
                           :name => "data",
                           :variable => "name"}],
                        [:text, "!"]]
  end

  it "should parse phrase with two rules" do
    tl = Otwtranslation::TokenisedLabel.new("You have {count::message} and {count::story}.")
    tl.label.should == [[:text, "You have "],
                        [:rule, {
                           :name => "count",
                           :variable => "message"}],
                        [:text, " and "],
                        [:rule, {
                           :name => "count",
                           :variable => "story"}],
                        [:text, "."]]
  end

  it "should parse plain curly braces as all text" do
    tl = Otwtranslation::TokenisedLabel.new("This {is} a test!")
    tl.label.should == [[:text, "This {is} a test!"]]
  end
    
  it "should apply simple data rule" do
    tl = Otwtranslation::TokenisedLabel.new("Hello {data::name}!")
    tl.apply_rules.should == "Hello name!"
  end

  it "should apply simple data rule with variables" do
    tl = Otwtranslation::TokenisedLabel.new("Hello {data::name}!")
    tl.apply_rules(:name => "Abby").should == "Hello Abby!"
  end


  it "should know that label is all text" do
    tl = Otwtranslation::TokenisedLabel.new("This {is} a test!")
    tl.all_text?.should == true
  end
  
  it "should know that label is not all text" do
    tl = Otwtranslation::TokenisedLabel.new("Hello {data::name}!")
    tl.all_text?.should == false
  end
  
end
