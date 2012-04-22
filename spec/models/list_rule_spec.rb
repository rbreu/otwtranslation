require 'spec_helper'

describe Otwtranslation::ListRule, "creation" do
  it "should save" do
    conditions = [["matches all", []]]
    actions = [["replace", ["Abby"]]]
    rule = Otwtranslation::ListRule.create(:conditions => conditions,
                                              :actions => actions,
                                              :locale => "de",
                                              :description => "foo")
    rule.reload
    rule.locale.should == "de"
    rule.description.should == "foo"
    rule.conditions.should == conditions
    rule.actions.should == actions
    rule.type.should == "Otwtranslation::ListRule"
  end
end

describe Otwtranslation::ListRule, "match" do

    describe "has less/equal elements than" do
    it "should handle basics" do
      conditions = [["has less/equal elements than", ["2"]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1]).should be_true
      rule.match?([1, 2]).should be_true
      rule.match?([1, 2, 3]).should be_false
    end

    it "should handle empty params" do
      conditions = [["has less/equal elements than", []]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1, 2, 3]).should be_false
    end

    it "should handle multiple params" do
      conditions = [["has less/equal elements than", ["1", "2"]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1]).should be_true
      rule.match?([1, 2]).should be_true
      rule.match?([1, 2, 3]).should be_false
    end

    it "should handle non-string param" do
      conditions = [["has less/equal elements than", [2]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1]).should be_true
      rule.match?([1, 2]).should be_true
      rule.match?([1, 2, 3]).should be_false
    end

    it "should handle non-list value" do
      conditions = [["has less/equal elements than", ["2"]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?(1).should be_false
    end

    it "should handle non-number param" do
      conditions = [["has less/equal elements than", ["foo"]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1, 2, 3]).should be_false
    end
  end
  
  describe "has more elements than" do
    it "should handle basics" do
      conditions = [["has more elements than", ["2"]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1]).should be_false
      rule.match?([1, 2]).should be_false
      rule.match?([1, 2, 3]).should be_true
    end

    it "should handle empty params" do
      conditions = [["has more elements than", []]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1, 2, 3]).should be_false
    end

    it "should handle multiple params" do
      conditions = [["has more elements than", ["3", "2"]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1]).should be_false
      rule.match?([1, 2]).should be_false
      rule.match?([1, 2, 3]).should be_true
    end

    it "should handle non-string param" do
      conditions = [["has more elements than", [2]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1]).should be_false
      rule.match?([1, 2]).should be_false
      rule.match?([1, 2, 3]).should be_true
    end

    it "should handle non-list value" do
      conditions = [["has more elements than", ["2"]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?(1).should be_false
    end

    it "should handle non-number param" do
      conditions = [["has more elements than", ["foo"]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1, 2, 3]).should be_true
    end
  end

  describe "has number of elements" do
    it "should handle basics" do
      conditions = [["has number of elements", ["2"]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1]).should be_false
      rule.match?([1, 2]).should be_true
      rule.match?([1, 2, 3]).should be_false
    end

    it "should handle empty params" do
      conditions = [["has number of elements", []]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1, 2, 3]).should be_false
    end

    it "should handle multiple params" do
      conditions = [["has number of elements", ["3", "2"]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1]).should be_false
      rule.match?([1, 2]).should be_true
      rule.match?([1, 2, 3]).should be_true
    end

    it "should handle non-string param" do
      conditions = [["has number of elements", [2]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1]).should be_false
      rule.match?([1, 2]).should be_true
      rule.match?([1, 2, 3]).should be_false
    end

    it "should handle non-list value" do
      conditions = [["has number of elements", ["2"]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?(1).should be_false
    end

    it "should handle non-number param" do
      conditions = [["has number of elements", ["foo"]]]
      rule = Otwtranslation::ListRule.new(:conditions => conditions)
      rule.match?([1, 2, 3]).should be_false
    end
  end
end

describe Otwtranslation::ListRule, "perform_actions" do

  describe "list to sentence" do
  
    it "should convert to sentence" do
      actions = [["list to sentence", [", ", " und ", " sowie "]]]
      rule = Otwtranslation::ListRule.new(:actions => actions)
      rule.perform_actions("names", ["Abby"]).should == "Abby"
      rule.perform_actions("names", ["Abby", "Bob"]).should == "Abby und Bob"
      rule.perform_actions("names", ["Abby", "Bob", "Clara"])
        .should == "Abby, Bob sowie Clara"
    end

    it "should handle missing params" do
      actions = [["list to sentence", []]]
      rule = Otwtranslation::ListRule.new(:actions => actions)
      rule.perform_actions("names", ["Abby", "Bob", "Clara"])
        .should == "AbbyBobClara"

      actions = [["list to sentence", ["; "]]]
      rule = Otwtranslation::ListRule.new(:actions => actions)
      rule.perform_actions("names", ["Abby", "Bob", "Clara"])
        .should == "Abby; BobClara"

      actions = [["list to sentence", ["; ", " und "]]]
      rule = Otwtranslation::ListRule.new(:actions => actions)
      rule.perform_actions("names", ["Abby", "Bob"])
        .should == "Abby und Bob"
    end

    it "should handle non-list values" do
      actions = [["list to sentence", [", ", " und ", " sowie "]]]
      rule = Otwtranslation::ListRule.new(:actions => actions)
      rule.perform_actions("names", 111).should == "111"
    end

    it "should handle non-string parameters" do
      actions = [["list to sentence", [1, 2, 3]]]
      rule = Otwtranslation::ListRule.new(:actions => actions)
      rule.perform_actions("names", ["Abby", "Bob", "Clara"])
        .should == "Abby1Bob3Clara"
    end
end

end
