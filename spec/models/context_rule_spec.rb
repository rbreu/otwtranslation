require 'spec_helper'

describe Otwtranslation::ContextRule, "creation" do
  it "should create empty conditions and actions lists" do
    rule = Otwtranslation::ContextRule.new()
    rule.conditions.should == []
    rule.actions.should == []
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
  
  it "should match is condition" do
    conditions = [["is", ["foo"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?("foo").should be_true
    rule.match?("bar").should be_false
    rule.match?('<a href="example.org">foo</a>').should be_true
    rule.match?('<a href="example.org">bar</a>').should be_false
  end
  
  it "should match is condition with numbers" do
    conditions = [["is", ["11"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?(11).should be_true
    rule.match?(0).should be_false
  end
  
  it "should match single is not rule" do
    conditions = [["is not", ["100"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?("101").should be_true
    rule.match?("100").should be_false
    rule.match?('<a href="example.org">101</a>').should be_true
    rule.match?('<a href="example.org">100</a>').should be_false
  end
  
  it "should match single is rule with list param" do
    conditions = [["is", ["foo", "bar"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?("foo").should be_true
    rule.match?("bar").should be_true
    rule.match?("baz").should be_false
    rule.match?('<a href="example.org">foo</a>').should be_true
    rule.match?('<a href="example.org">bar</a>').should be_true
    rule.match?('<a href="example.org">baz</a>').should be_false
  end
  
  it "should match double ends with/starts with rule" do
    conditions = [["ends with", ["x", "s"]], ["starts with", ["A", "a"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    
    rule.match?("Abby").should be_false
    rule.match?("Andreas").should be_true
    rule.match?("Alex").should be_true
    
    rule.match?('<a href="example.org">Abby</a>').should be_false
    rule.match?('<a href="example.org">Andreas</a>').should be_true
    rule.match?('<a href="example.org">Alex</a>').should be_true
                  
    rule.match?("abby").should be_false
    rule.match?("andreas").should be_true
    rule.match?("alex").should be_true
                  
    rule.match?("Bobby").should be_false
    rule.match?("Boss").should be_false
    rule.match?("Linux").should be_false
  end

  it "should match does not end with rule" do
    conditions = [["does not end with", ["x", "s"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?("Abby").should be_true
    rule.match?("Andreas").should be_false
    rule.match?("Alex").should be_false
    
    rule.match?('<a href="example.org">Abby</a>').should be_true
    rule.match?('<a href="example.org">Andreas</a>').should be_false
    rule.match?('<a href="example.org">Alex</a>').should be_false
  end
    
  it "should match does not start with rule" do
    conditions = [["does not start with", ["A", "a"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?("Abby").should be_false
    rule.match?("alex").should be_false
    rule.match?("bob").should be_true
    rule.match?('<a href="example.org">Abby</a>').should be_false
    rule.match?('<a href="example.org">alex</a>').should be_false
    rule.match?('<a href="example.org">bob</a>').should be_true
  end
    
  it "should match lesser/equal than" do
    conditions = [["is lesser/equal than", ["2"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?(1).should be_true
    rule.match?(2).should be_true
    rule.match?(3).should be_false
    
    rule.match?("1").should be_true
    rule.match?("2").should be_true
    rule.match?("3").should be_false

    rule.match?('<a href="example.org">1</a>').should be_true
    rule.match?('<a href="example.org">2</a>').should be_true
    rule.match?('<a href="example.org">3</a>').should be_false
  end
    
  it "should match greater than" do
    conditions = [["is greater than", ["2"]]]
    rule = Otwtranslation::ContextRule.new(:conditions => conditions)
    rule.match?(1).should be_false
    rule.match?(2).should be_false
    rule.match?(3).should be_true
    
    rule.match?("1").should be_false
    rule.match?("2").should be_false
    rule.match?("3").should be_true

    rule.match?('<a href="example.org">1</a>').should be_false
    rule.match?('<a href="example.org">2</a>').should be_false
    rule.match?('<a href="example.org">3</a>').should be_true
  end
end


describe Otwtranslation::ContextRule, "perform_actions" do
  
  it "should handle no actions" do
    actions = []
    rule = Otwtranslation::ContextRule.new(:actions => actions)
    rule.perform_actions("name", "Abby").should == "Abby"
  end

  it "should apply replace rule" do
    actions = [["replace", ["Alice"]]]
    rule = Otwtranslation::ContextRule.new(:actions => actions)
    rule.perform_actions("name", "Abby").should == "Alice"
  end

  it "should apply append rule" do
    actions = [["append", ["'s"]]]
    rule = Otwtranslation::ContextRule.new(:actions => actions)
    rule.perform_actions("name", "Abby").should == "Abby's"
  end

  it "should apply prepend rule" do
    actions = [["prepend", ["d'"]]]
    rule = Otwtranslation::ContextRule.new(:actions => actions)
    rule.perform_actions("name", "Abby").should == "d'Abby"
  end

  it "should auto pluralize" do
    actions = [["auto pluralize", []]]
    rule = Otwtranslation::ContextRule.new(:actions => actions)
    rule.perform_actions("message", 1).should == "1 message"
    rule.perform_actions("message", 2).should == "2 messages"
  end

  it "should handle two actions" do
    actions = [["append", ["'s"]], ["prepend", ["of "]]]
    rule = Otwtranslation::ContextRule.new(:actions => actions)
    rule.perform_actions("name", "Abby").should == "of Abby's"
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

    it "should handle one rule with set variables" do
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
    
    it "should replace" do
      @rule.actions = [["replace", ["foo"]]]
      @rule.save
      
      result = Otwtranslation::ContextRule.
        apply_rules("This is {general::name} fic", "en", :name => 'Abby')
      result.should == "This is foo fic"

      result = Otwtranslation::ContextRule.
        apply_rules("This is {general::name} fic", "en",
                    :name => '<a href="example.org">Abby</a>')
      result.should == "This is <a href=\"example.org\">foo</a> fic"
    end

    it "should append" do
      @rule.actions = [["append", ["'s"]]]
      @rule.save
      
      result = Otwtranslation::ContextRule.
        apply_rules("This is {general::name} fic", "en", :name => 'Abby')
      result.should == "This is Abby's fic"

      result = Otwtranslation::ContextRule.
        apply_rules("This is {general::name} fic", "en",
                    :name => '<a href="example.org">Abby</a>')
      result.should == "This is <a href=\"example.org\">Abby's</a> fic"
    end

    it "should prepend" do
      @rule.actions = [["prepend", ["Hi "]]]
      @rule.save
      
      result = Otwtranslation::ContextRule.
        apply_rules("{general::name}.", "en", :name => 'Abby')
      result.should == "Hi Abby."

      result = Otwtranslation::ContextRule.
        apply_rules("{general::name}.", "en",
                    :name => '<a href="example.org">Abby</a>')
      result.should == "<a href=\"example.org\">Hi Abby</a>."
    end

    it "should auto pluralize" do
      @rule.actions = [["auto pluralize", []]]
      @rule.save
      
      result = Otwtranslation::ContextRule.
        apply_rules("You have {general::apple}.", "en", :apple => 2)
      result.should == "You have 2 apples."

      result = Otwtranslation::ContextRule.
        apply_rules("You have {general::apple}.", "en",
                    :apple => '<a href="example.org">2</a>')
      result.should == "You have <a href=\"example.org\">2 apples</a>."
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
