require 'spec_helper'

describe Otwtranslation::GeneralRule, "creation" do
  it "should save" do
    conditions = [["matches all", []]]
    actions = [["replace", {:append => "Abby"}]]
    rule = Otwtranslation::GeneralRule.create(:conditions => conditions,
                                              :actions => actions,
                                              :language_short => "de",
                                              :description => "foo")
    rule.reload
    rule.language_short.should == "de"
    rule.description.should == "foo"
    rule.conditions.should == conditions
    rule.actions.should == actions
    rule.type.should == "Otwtranslation::GeneralRule"
  end
end
