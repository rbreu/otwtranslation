require 'spec_helper'

describe Otwtranslation::ListRule, "creation" do
  it "should save" do
    conditions = [["matches all", []]]
    actions = [["replace", {:append => "Abby"}]]
    rule = Otwtranslation::ListRule.create(:conditions => conditions,
                                              :actions => actions,
                                              :language_short => "de",
                                              :description => "foo")
    rule = Otwtranslation::ListRule.find(rule.id)
    rule.language_short.should == "de"
    rule.description.should == "foo"
    rule.conditions.should == conditions
    rule.actions.should == actions
    rule.type.should == "Otwtranslation::ListRule"
  end
end

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

describe Otwtranslation::ListRule, "perform_actions" do
  
  it "should apply list to sentence" do
    actions = [["list to sentence",
                {:words_connector => "; ",
                 :two_words_connector => " und ",
                 :last_word_connector => " sowie "}
               ]]
    rule = Otwtranslation::ListRule.new(:actions => actions)
    rule.perform_actions("names", ["Abby"]).should == "Abby"
    rule.perform_actions("names", ["Abby", "Bob"]).should == "Abby und Bob"
    rule.perform_actions("names", ["Abby", "Bob", "Clara"])
      .should == "Abby; Bob sowie Clara"
  end

end
