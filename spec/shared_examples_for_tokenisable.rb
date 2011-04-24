require 'spec_helper'

shared_examples_for "tokenisable" do
  
  it "should parse phrase with one rule" do
    @tokenisable.label = "Hello {data::name}!"
    @tokenisable.tokenise_label
    @tokenisable.tokenised_label.should == [[:text, "Hello "],
                                            [:rule, {
                                               :name => "data",
                                               :variable => "name"}],
                                            [:text, "!"]]
  end

  it "should parse phrase with two rules" do
    @tokenisable.label = "You have {count::message} and {count::story}."
    @tokenisable.tokenise_label
    @tokenisable.tokenised_label.should == [[:text, "You have "],
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
    @tokenisable.label = "This {is} a test!"
    @tokenisable.tokenise_label
    @tokenisable.tokenised_label.should == [[:text, "This {is} a test!"]]
  end
    
  it "should apply simple data rule" do
    @tokenisable.label = "Hello {data::name}!"
    @tokenisable.apply_rules.should == "Hello name!"
  end

  it "should apply simple data rule with variables" do
    @tokenisable.label = "Hello {data::name}!"
    @tokenisable.apply_rules(:name => "Abby").should == "Hello Abby!"
  end


  it "should know that label is all text" do
    @tokenisable.label = "This {is} a test!"
    @tokenisable.all_text?.should == true
  end
  
  it "should know that label is not all text" do
    @tokenisable.label = "Hello {data::name}!"
    @tokenisable.all_text?.should == false
  end
  
end
