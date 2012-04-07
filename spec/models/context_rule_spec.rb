# -*- coding: utf-8 -*-
require 'spec_helper'

describe Otwtranslation::ContextRule, "creation" do
  let (:rule) { Otwtranslation::GeneralRule.new(:language_short => "de") }

  it "should create empty conditions and actions lists" do
    rule.conditions.should == []
    rule.actions.should == []
  end

  it "should not save conditions if not Array" do
    rule.conditions = ""
    rule.save.should be_false
    rule.errors[:conditions].should_not be_empty
  end

  it "should not save conditions if elements not Arrays" do
    rule.conditions = ["is"]
    rule.save.should be_false
    rule.errors[:conditions].should_not be_empty
  end

  it "should not save conditions if elements not Arrays of size 2" do
    rule.conditions = [["is"]]
    rule.save.should be_false
    rule.errors[:conditions].should_not be_empty
  end

  it "should not save invalid condition type" do
    rule.conditions = [["foobar", []]]
    rule.save.should be_false
    rule.errors[:conditions].should_not be_empty
  end

  it "should not save invalid condition parameters" do
    rule.conditions = [["is", 1]]
    rule.save.should be_false
    rule.errors[:conditions].should_not be_empty
  end

  it "should not save actions if not Array" do
    rule.actions = ""
    rule.save.should be_false
    rule.errors[:actions].should_not be_empty
  end

  it "should not save actions if elements not Arrays" do
    rule.actions = ["append"]
    rule.save.should be_false
    rule.errors[:actions].should_not be_empty
  end

  it "should not save actions if elements not Arrays of size 2" do
    rule.actions = [["append"]]
    rule.save.should be_false
    rule.errors[:actions].should_not be_empty
  end

  it "should not save invalid action type" do
    rule.actions = [["foobar", []]]
    rule.save.should be_false
    rule.errors[:actions].should_not be_empty
  end

  it "should not save invalid action parameters" do
    rule.actions = [["append", 1]]
    rule.save.should be_false
    rule.errors[:actions].should_not be_empty
  end


end

describe Otwtranslation::ContextRule, "deletetion" do

  before(:each) do
    @language = FactoryGirl.create(:language)
    @rule = FactoryGirl.create(:possessive_rule, :language => @language)
    @rule2 = FactoryGirl.create(:possessive_rule, :language => @language)
    @translation = FactoryGirl.create(:translation,
                                      :language => @language,
                                      :approved => true,
                                      :rules => [@rule.id])
  end

  it "should remove rule from translation" do
    @rule.destroy
    @translation.reload
    @translation.rules.should be_empty
    @translation.approved.should be_false
  end

  it "should leave unaffected translations untouched" do
    @translation.rules = [@rule2.id]
    @translation.save!
    @rule.destroy
    @translation.reload
    @translation.rules.should == [@rule2.id]
    @translation.approved.should be_true
  end

end


describe Otwtranslation::ContextRule, "tokenize_label" do
  it "should parse phrase with one rule" do
    Otwtranslation::ContextRule.tokenize_label("Hello {general::name}!")
      .should == [[:text, "Hello "],
                  [:rule, {:name => "general", :variable => "name"}],
                  [:text, "!"]]
  end

  it "should handle variable names with underscores" do
    Otwtranslation::ContextRule.tokenize_label("{general::my_name}")
      .should == [[:rule, {:name => "general", :variable => "my_name"}]]
  end

  it "should parse phrase with two rules" do
     Otwtranslation::ContextRule.tokenize_label("You have {quantity::message} and {quantity::story}.")
      .should == [[:text, "You have "],
                  [:rule, {:name => "quantity", :variable => "message"}],
                  [:text, " and "],
                  [:rule, {:name => "quantity", :variable => "story"}],
                  [:text, "."]]
  end

  it "should parse plain curly braces as all text" do
    Otwtranslation::ContextRule.tokenize_label("This {is} a test!")
      .should == [[:text, "This {is} a test!"]]
  end
    
end

describe Otwtranslation::ContextRule, "label_all_text?" do
  it "should know that label is all text" do
    Otwtranslation::ContextRule.label_all_text?("This {is} a test!")
      .should be_true
  end
  
  it "should know that label has context rules" do
    Otwtranslation::ContextRule.label_all_text?("You have {quantity::message}.")
      .should be_false
  end
end

describe Otwtranslation::ContextRule, "match" do
  
  it "should not match empty condition" do
    conditions = []
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?("Abby").should be_false
  end
  
  it "should match matches all condition" do
    conditions = [["matches all", []]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?("Abby").should be_true
    rule.match?('<a href="example.org">label</a>').should be_true
  end

  describe "is" do
    it "should handle basics" do
      conditions = [["is", ["foo"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_true
      rule.match?("bar").should be_false
    end

    it "should handle links" do
      conditions = [["is", ["foo"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?('<a href="example.org">foo</a>').should be_true
      rule.match?('<a href="example.org">bar</a>').should be_false
    end

    it "should not match empty params" do
      conditions = [["is", []]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_false
    end

    it "should handle multiple params" do
      conditions = [["is", ["foo", "bar"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_true
      rule.match?("bar").should be_true
      rule.match?("baz").should be_false
    end

    it "should handle non-string param" do
      conditions = [["is", [1]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("1").should be_true
      rule.match?("2").should be_false
    end

    it "should handle non-string value" do
      conditions = [["is", ["1"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?(1).should be_true
      rule.match?(2).should be_false
    end
  end

  describe "is not" do
    it "should handle basics" do
      conditions = [["is not", ["foo"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_false
      rule.match?("bar").should be_true
    end

    it "should handle links" do
      conditions = [["is not", ["foo"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?('<a href="example.org">foo</a>').should be_false
      rule.match?('<a href="example.org">bar</a>').should be_true
    end

    it "should match empty params" do
      conditions = [["is not", []]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_true
    end

    it "should handle multiple params" do
      conditions = [["is not", ["foo", "bar"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_false
      rule.match?("bar").should be_false
      rule.match?("baz").should be_true
    end

    it "should handle non-string param" do
      conditions = [["is not", [1]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("1").should be_false
      rule.match?("2").should be_true
    end

    it "should handle non-string value" do
      conditions = [["is not", ["1"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?(1).should be_false
      rule.match?(2).should be_true
    end
  end


  describe "starts with" do
    it "should handle basics" do
      conditions = [["starts with", ["f"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_true
      rule.match?("bar").should be_false
    end

    it "should handle links" do
      conditions = [["starts with", ["f"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?('<a href="example.org">foo</a>').should be_true
      rule.match?('<a href="example.org">bar</a>').should be_false
    end

    it "should not match empty params" do
      conditions = [["starts with", []]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_false
    end

    it "should handle multiple params" do
      conditions = [["starts with", ["f", "d"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_true
      rule.match?("doo").should be_true
      rule.match?("baz").should be_false
    end

    it "should handle non-string param" do
      conditions = [["starts with", [1]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("123").should be_true
      rule.match?("234").should be_false
    end

    it "should handle non-string value" do
      conditions = [["starts with", ["1"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?(123).should be_true
      rule.match?(234).should be_false
    end
  end

  describe "does not start with" do
    it "should handle basics" do
      conditions = [["does not start with", ["f"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_false
      rule.match?("bar").should be_true
    end

    it "should handle links" do
      conditions = [["does not start with", ["f"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?('<a href="example.org">foo</a>').should be_false
      rule.match?('<a href="example.org">bar</a>').should be_true
    end

    it "should match empty params" do
      conditions = [["does not start with", []]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_true
    end

    it "should handle multiple params" do
      conditions = [["does not start with", ["f", "d"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_false
      rule.match?("doo").should be_false
      rule.match?("baz").should be_true
    end

    it "should handle non-string param" do
      conditions = [["does not start with", [1]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("123").should be_false
      rule.match?("234").should be_true
    end

    it "should handle non-string value" do
      conditions = [["does not start with", ["1"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?(123).should be_false
      rule.match?(234).should be_true
    end
  end

  describe "ends with" do
    it "should handle basics" do
      conditions = [["ends with", ["o"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_true
      rule.match?("bar").should be_false
    end

    it "should handle links" do
      conditions = [["ends with", ["o"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?('<a href="example.org">foo</a>').should be_true
      rule.match?('<a href="example.org">bar</a>').should be_false
    end

    it "should not match empty params" do
      conditions = [["ends with", []]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_false
    end

    it "should handle multiple params" do
      conditions = [["ends with", ["o", "r"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_true
      rule.match?("bar").should be_true
      rule.match?("baz").should be_false
    end

    it "should handle non-string param" do
      conditions = [["ends with", [3]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("123").should be_true
      rule.match?("234").should be_false
    end

    it "should handle non-string value" do
      conditions = [["ends with", ["3"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?(123).should be_true
      rule.match?(234).should be_false
    end
  end

  describe "does not end with" do
    it "should handle basics" do
      conditions = [["does not end with", ["o"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_false
      rule.match?("bar").should be_true
    end

    it "should handle links" do
      conditions = [["does not end with", ["o"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?('<a href="example.org">foo</a>').should be_false
      rule.match?('<a href="example.org">bar</a>').should be_true
    end

    it "should match empty params" do
      conditions = [["does not end with", []]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_true
    end

    it "should handle multiple params" do
      conditions = [["does not end with", ["o", "r"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("foo").should be_false
      rule.match?("bar").should be_false
      rule.match?("baz").should be_true
    end

    it "should handle non-string param" do
      conditions = [["does not end with", [3]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("123").should be_false
      rule.match?("234").should be_true
    end

    it "should handle non-string value" do
      conditions = [["does not end with", ["3"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?(123).should be_false
      rule.match?(234).should be_true
    end
  end

  describe "is less than or equal" do
    it "should handle basics" do
      conditions = [["is less than or equal", ["2"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("1").should be_true
      rule.match?("2").should be_true
      rule.match?("3").should be_false
    end

    it "should handle links" do
      conditions = [["is less than or equal", ["2"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?('<a href="example.org">1</a>').should be_true
      rule.match?('<a href="example.org">2</a>').should be_true
      rule.match?('<a href="example.org">3</a>').should be_false
    end

    it "should handle empty params" do
      conditions = [["is less than or equal", []]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("2").should be_false
    end

    it "should handle multiple params" do
      conditions = [["is less than or equal", ["1", "2"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("1").should be_true
      rule.match?("2").should be_true
      rule.match?("3").should be_false
    end

    it "should handle non-string param" do
      conditions = [["is less than or equal", [2]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("1").should be_true
      rule.match?("2").should be_true
      rule.match?("3").should be_false
    end

    it "should handle non-string value" do
      conditions = [["is less than or equal", ["2"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?(1).should be_true
      rule.match?(2).should be_true
      rule.match?(3).should be_false
    end

    it "should handle non-number param/value" do
      conditions = [["is less than or equal", ["foo"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("aaa").should be_true
      rule.match?("zzz").should be_true
    end
  end

  describe "is greater than" do
    it "should handle basics" do
      conditions = [["is greater than", ["2"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("1").should be_false
      rule.match?("2").should be_false
      rule.match?("3").should be_true
    end

    it "should handle links" do
      conditions = [["is greater than", ["2"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?('<a href="example.org">1</a>').should be_false
      rule.match?('<a href="example.org">2</a>').should be_false
      rule.match?('<a href="example.org">3</a>').should be_true
    end

    it "should handle empty params" do
      conditions = [["is greater than", []]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("2").should be_false
    end

    it "should handle multiple params" do
      conditions = [["is greater than", ["3", "2"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("1").should be_false
      rule.match?("2").should be_false
      rule.match?("3").should be_true
    end

    it "should handle non-string param" do
      conditions = [["is greater than", [2]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("1").should be_false
      rule.match?("2").should be_false
      rule.match?("3").should be_true
    end

    it "should handle non-string value" do
      conditions = [["is greater than", ["2"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?(1).should be_false
      rule.match?(2).should be_false
      rule.match?(3).should be_true
    end

    it "should handle non-number param/value" do
      conditions = [["is greater than", ["foo"]]]
      rule = Otwtranslation::ContextRule.new(:conditions => conditions)
      rule.match?("aaa").should be_false
      rule.match?("zzz").should be_false
    end
  end

  
  it "should match double ends with/starts with rule" do
    conditions = [["ends with", ["x", "s"]], ["starts with", ["A", "a"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    
    rule.match?("Abby").should be_false
    rule.match?("Andreas").should be_true
    rule.match?("Alex").should be_true
    
    rule.match?("abby").should be_false
    rule.match?("andreas").should be_true
    rule.match?("alex").should be_true
                  
    rule.match?("Bobby").should be_false
    rule.match?("Boss").should be_false
    rule.match?("Linux").should be_false
  end

end


describe Otwtranslation::ContextRule, "perform_actions" do
  
  it "should handle no actions" do
    actions = []
    rule = Otwtranslation::ContextRule.new(:actions => actions)
    rule.perform_actions("name", "Abby").should == "Abby"
  end

  it "should handle two actions" do
    actions = [["append", ["'s"]], ["prepend", ["of "]]]
    rule = Otwtranslation::ContextRule.new(:actions => actions)
    rule.perform_actions("name", "Abby").should == "of Abby's"
  end

  describe "replace rule" do
    
    it "should replace" do
      actions = [["replace", ["Alice"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "Alice"
    end

    it "should handle missing params" do
      actions = [["replace", []]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "Abby"
    end
    
    it "should handle non-string params" do
      actions = [["replace", [111]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "111"
    end

    it "should handle non-string value" do
      actions = [["replace", ["!"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", 111).should == "!"
    end

    it "should handle links" do
      actions = [["replace", ["Alice"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "<a href='ao3.org'>Abby</a>")
        .should == "<a href='ao3.org'>Alice</a>"
    end
  end

  describe "append rule" do
    
    it "should append" do
      actions = [["append", ["!"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "Abby!"
    end

    it "should handle missing params" do
      actions = [["append", []]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "Abby"
    end
    
    it "should handle non-string params" do
      actions = [["append", [111]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "Abby111"
    end

    it "should handle non-string value" do
      actions = [["append", ["!"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", 111).should == "111!"
    end

    it "should handle links" do
      actions = [["append", ["!"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "<a href='ao3.org'>Abby</a>")
        .should == "<a href='ao3.org'>Abby!</a>"
    end
  end

  describe "prepend rule" do
    
    it "should prepend" do
      actions = [["prepend", ["!"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "!Abby"
    end

    it "should handle missing params" do
      actions = [["prepend", []]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "Abby"
    end
    
    it "should handle non-string params" do
      actions = [["prepend", [111]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "111Abby"
    end

    it "should handle non-string value" do
      actions = [["prepend", ["!"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", 111).should == "!111"
    end

    it "should handle links" do
      actions = [["prepend", ["!"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "<a href='ao3.org'>Abby</a>")
        .should == "<a href='ao3.org'>!Abby</a>"
    end
  end

  describe "remove last chars rule" do
    
    it "should remove last chars" do
      actions = [["remove last chars", ["1"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "Abb"
    end

    it "should count unicode chars correctly" do
      actions = [["remove last chars", ["1"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "daß").should == "da"
    end

    it "should handle missing params" do
      actions = [["remove last chars", []]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "Abby"
    end
    
    it "should handle int param" do
      actions = [["remove last chars", [1]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "Abb"
    end

    it "should handle non-number param" do
      actions = [["remove last chars", ["foo"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "Abby"
    end
    
    it "should handle non-string value" do
      actions = [["remove last chars", ["1"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", 123).should == "12"
    end

    it "should handle links" do
      actions = [["remove last chars", [1]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "<a href='ao3.org'>Abby</a>")
        .should == "<a href='ao3.org'>Abb</a>"
    end
  end

  describe "remove first chars rule" do
    
    it "should remove first chars" do
      actions = [["remove first chars", ["1"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "bby"
    end

    it "should count unicode chars correctly" do
      actions = [["remove first chars", ["1"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Émile").should == "mile"
    end

    it "should handle missing params" do
      actions = [["remove first chars", []]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "Abby"
    end
    
    it "should handle int param" do
      actions = [["remove first chars", [1]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "bby"
    end

    it "should handle non-number param" do
      actions = [["remove first chars", ["foo"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "Abby").should == "Abby"
    end
    
    it "should handle non-string value" do
      actions = [["remove first chars", ["1"]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", 123).should == "23"
    end

    it "should handle links" do
      actions = [["remove first chars", [1]]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("name", "<a href='ao3.org'>Abby</a>")
        .should == "<a href='ao3.org'>bby</a>"
    end
  end

  describe "auto pluralize rule" do
    
    it "should auto pluralize" do
      actions = [["auto pluralize", []]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("message", 1).should == "1 message"
      rule.perform_actions("message", 2).should == "2 messages"
    end

    it "should handle string value" do
      actions = [["auto pluralize", []]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("message", "1").should == "1 message"
      rule.perform_actions("message", "2").should == "2 messages"
    end

    it "should handle non-number value" do
      actions = [["auto pluralize", []]]
      rule = Otwtranslation::ContextRule.new(:actions => actions)
      rule.perform_actions("message", "foo").should == "foo messages"
    end
  end
end
  
describe Otwtranslation::ContextRule, "apply_rules" do

  context "when there are no rules" do
    
    it "should insert" do
      result = Otwtranslation::ContextRule.
        apply_rules("Hi {general::name}!", "en", :name => "Abby")
      result.should == "Hi Abby!"
    end

    it "should insert numbers" do
      result = Otwtranslation::ContextRule.
        apply_rules("The answer is {general::number}!", "en", :number => 42)
      result.should == "The answer is 42!"
    end
  end

  context "when there are rules" do
    before(:each) do
      conditions = [["matches all", []]]
      @rule = Otwtranslation::GeneralRule.create(:conditions => conditions,
                                                 :language_short => "en",
                                                 :actions => [])
    end
    
    it "should handle one rule with no variables" do
      result = Otwtranslation::ContextRule.
        apply_rules("This is {general::name} fic", "en")
      result.should == "This is {general::name} fic"
    end

    it "should handle no actions with variables" do
      result = Otwtranslation::ContextRule.
        apply_rules("Hi {general::name}!", "en", :name => "Abby")
      result.should == "Hi Abby!"
    end

    it "should handle no actions with number variables" do
      result = Otwtranslation::ContextRule.
        apply_rules("The answer is {general::number}!", "en", :number => 42)
      result.should == "The answer is 42!"
    end

    it "should handle one rule with variables" do
      @rule.actions = [["append", ["'s"]]]
      @rule.save
      result = Otwtranslation::ContextRule.
        apply_rules("This is {general::name} fic", "en", :name => "Abby")
      result.should == "This is Abby's fic"
    end

    it "should handle two rules with their own variables" do
      @rule.actions = [["append", ["'s"]]]
      @rule.save
      result = Otwtranslation::ContextRule.
        apply_rules("This is {general::author} fic and {general::artist} art.",
                    "en", :author => "Abby", :artist => "Becky")
      result.should == "This is Abby's fic and Becky's art."
    end
  end    

end


describe Otwtranslation::ContextRule, "rule_combinations" do

  before(:each) do
    @gen = Otwtranslation::GeneralRule.create(:language_short => "en",
                                              :conditions => [["matches all", []]])
    @quant1 = Otwtranslation::QuantityRule.create(:language_short => "en",
                                                  :conditions => [["is", ["1"]]])
    @quant2 = Otwtranslation::QuantityRule.create(:language_short => "en",
                                                  :conditions => [["matches all", []]])
  end
  

  it "should find no combinations" do
    label = "Hello World!"
    Otwtranslation::ContextRule.rule_combinations(label, "en")
      .should == []
  end

  it "should find one combination" do
    label = "Hello {general::name}!"
    Otwtranslation::ContextRule.rule_combinations(label, "en")
      .should =~ [[@gen]]
  end

  it "should find one combination" do
    label = "Hello {general::author} and hello {general::artist}!"
    Otwtranslation::ContextRule.rule_combinations(label, "en")
      .should =~ [[@gen, @gen]]
  end

  it "should find two combinations" do
    label = "You have {quantity::message}!"
    Otwtranslation::ContextRule.rule_combinations(label, "en")
      .should =~ [[@quant1], [@quant2]]
  end

  it "should find two combinations" do
    label = "Hello {general::name}. You have {quantity::message}!"
    Otwtranslation::ContextRule.rule_combinations(label, "en")
      .should =~ [[@gen, @quant1], [@gen, @quant2]]
  end

  it "should find four combinations" do
    label = "You have {quantity::message} and {quantity::notification}!"
    Otwtranslation::ContextRule.rule_combinations(label, "en")
      .should =~ [[@quant1, @quant1], [@quant1, @quant2],
                  [@quant2, @quant1], [@quant2, @quant2]]
  end

  it "should find eight combinations" do
    label = " {quantity::a} {quantity::b} {quantity::c}"
    Otwtranslation::ContextRule.rule_combinations(label, "en")
      .should =~ [[@quant1, @quant1, @quant1],
                  [@quant1, @quant1, @quant2],
                  [@quant1, @quant2, @quant1],
                  [@quant1, @quant2, @quant2],
                  [@quant2, @quant1, @quant1],
                  [@quant2, @quant1, @quant2],
                  [@quant2, @quant2, @quant1],
                  [@quant2, @quant2, @quant2]]
  end

end


describe Otwtranslation::ContextRule, "matching_rules" do

  before(:each) do
    @gen = Otwtranslation::GeneralRule.create(:language_short => "en",
                                              :conditions => [["matches all", []]])
    @quant1 = Otwtranslation::QuantityRule.create(:language_short => "en",
                                                  :conditions => [["is", ["1"]]])
    @quant2 = Otwtranslation::QuantityRule.create(:language_short => "en",
                                                  :conditions => [["matches all", []]])
  end
  

  it "should find no rules" do
    label = "Hello World!"
    Otwtranslation::ContextRule.matching_rules(label, "en")
      .should == []
  end

  it "should find one general rule" do
    label = "Hello {general::name}!"
    Otwtranslation::ContextRule.matching_rules(label, "en",
                                               :name => "Abby")
      .should == [@gen]
  end

  it "should find two general rules" do
    label = "Hello {general::author} and hello {general::artist}!"
    Otwtranslation::ContextRule.matching_rules(label, "en",
                                               :author => "Alice",
                                               :artist => "Bob")
      .should == [@gen, @gen]
  end

  it "should find one quantity rule" do
    label = "You have {quantity::message}!"
    Otwtranslation::ContextRule.matching_rules(label, "en", :message => 1)
      .should == [@quant1]
    Otwtranslation::ContextRule.matching_rules(label, "en", :message => 2)
      .should == [@quant2]
  end

  it "should find one general rule and one quantity rule" do
    label = "Hello {general::name}. You have {quantity::message}!"
    Otwtranslation::ContextRule.matching_rules(label, "en",
                                               :name => "Abby", :message => 1)
      .should == [@gen, @quant1]
    Otwtranslation::ContextRule.matching_rules(label, "en",
                                               :name => "Abby", :message => 2)
      .should == [@gen, @quant2]
  end

  it "should find two quantity rules" do
    label = "You have {quantity::message} and {quantity::notification}!"
    Otwtranslation::ContextRule.matching_rules(label, "en",
                                               :message => 1,
                                               :notification => 1)
      .should == [@quant1, @quant1]

    Otwtranslation::ContextRule.matching_rules(label, "en",
                                               :message => 1,
                                               :notification => 2)
      .should == [@quant1, @quant2]

    Otwtranslation::ContextRule.matching_rules(label, "en",
                                               :message => 2,
                                               :notification => 1)
      .should == [@quant2, @quant1]

    Otwtranslation::ContextRule.matching_rules(label, "en",
                                               :message => 2,
                                               :notification => 2)
      .should == [@quant2, @quant2]

  end

  it "should find three quantity rules" do
    label = " {quantity::a} {quantity::b} {quantity::c}"
    Otwtranslation::ContextRule.matching_rules(label, "en",
                                               :a => 1, :b => 2, :c => 1)
      .should == [@quant1, @quant2, @quant1]
    Otwtranslation::ContextRule.matching_rules(label, "en",
                                               :a => 1, :b => 1, :c => 2)
      .should == [@quant1, @quant1, @quant2]
  end

end
