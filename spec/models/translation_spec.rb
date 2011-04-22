require 'spec_helper'

describe Otwtranslation::Translation do

  before(:each) do
    @language = Factory.create(:language)
    @phrase = Factory.create(:phrase)
  end

  it "should create a new translation" do
    translation = Otwtranslation::Translation.new(:label => "irgendwas",
                                                  :approved => false)
    translation.language = @language
    translation.phrase = @phrase
    
    translation.save.should == true

    translation = Otwtranslation::Translation.first
    translation.label.should == "irgendwas"
    translation.approved.should == false
  end

  it "should let basic inline HTML untouched" do
    label = "<em>foo</em><strong>bar</strong>"
    translation = Otwtranslation::Translation.new(:label => label,
                                                  :language_short => "de",
                                                  :phrase_key => "somekey")
    translation.language = @language
    translation.phrase = @phrase
    translation.save.should == true
    translation.label.should == label
  end

  it "should remove weird HTML" do
    label = "<blah>foo</blah><a>bar</a>"
    translation = Otwtranslation::Translation.new(:label => label,
                                                  :language_short => "de",
                                                  :phrase_key => "somekey")
    translation.language = @language
    translation.phrase = @phrase
    translation.save.should == true
    translation.label.should_not =~ /<\/{0,1}blah>/
    translation.label.should_not =~ /<\/{0,1}a>/
  end
end
