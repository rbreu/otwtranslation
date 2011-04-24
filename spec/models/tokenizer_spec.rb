require 'spec_helper'

describe Otwtranslation::Tokenizer do
  
  it "should parse phrase with one rule" do
    Otwtranslation::Tokenizer.tokenize_label("Hello {data::name}!")
      .should == [[:text, "Hello "],
                  [:rule, {:name => "data", :variable => "name"}],
                  [:text, "!"]]
  end

  it "should parse phrase with two rules" do
     Otwtranslation::Tokenizer.tokenize_label("You have {count::message} and {count::story}.")
      .should == [[:text, "You have "],
                  [:rule, {:name => "count", :variable => "message"}],
                  [:text, " and "],
                  [:rule, {:name => "count", :variable => "story"}],
                  [:text, "."]]
  end

  it "should parse plain curly braces as all text" do
    Otwtranslation::Tokenizer.tokenize_label("This {is} a test!")
      .should == [[:text, "This {is} a test!"]]
  end
    
  it "should apply simple data rule" do
    Otwtranslation::Tokenizer.apply_rules("Hello {data::name}!")
      .should == "Hello {data::name}!"
  end

  it "should apply simple data rule with variables" do
    Otwtranslation::Tokenizer.apply_rules("Hello {data::name}!", :name => "Abby")
      .should == "Hello Abby!"
  end


  it "should know that label is all text" do
    Otwtranslation::Tokenizer.all_text_or_data?("This {is} a test!")
      .should == true
  end
  
  it "should know that label is only text and data" do
    Otwtranslation::Tokenizer.all_text_or_data?("Hello {data::name}!")
      .should == true
  end
  
  it "should know that label has context rules" do
    Otwtranslation::Tokenizer.all_text_or_data?("You have {count::message}.")
      .should == false
  end
  
end
