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
    translation.rules.should == []
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

describe Otwtranslation::Translation, "for_language" do
   before(:each) do
    @de = Factory.create(:language, :name => "Deutsch")
    @nl = Factory.create(:language, :name => "Nederlands")
    @phrase = Factory.create(:phrase)
    
    Factory.create(:translation, :language => @de, :phrase => @phrase)
    Factory.create(:translation, :language => @de, :phrase => @phrase)
    Factory.create(:translation, :language => @nl, :phrase => @phrase)
  end

  it "should find german translations" do
    t = Otwtranslation::Translation.for_language(@de)
    t.size.should == 2
    t.first.language_short.should == @de.short
    t.last.language_short.should == @de.short
    t.should == Otwtranslation::Translation.for_language(@de.short)

  end

  it "should find dutch translations" do
    t = Otwtranslation::Translation.for_language(@nl)
    t.size.should == 1
    t.first.language_short.should == @nl.short
    t.should == Otwtranslation::Translation.for_language(@nl.short)
  end
end


describe Otwtranslation::Translation, "for_variables" do
   before(:each) do
    @de = Factory.create(:language, :name => "Deutsch")
    @phrase = Factory.create(:phrase, :label => "{possessive::name}")
    rule1 = Factory.create(:possessive_rule, :language => @de,
                           :conditions => [["is", ["foo"]]])
    rule2 = Factory.create(:possessive_rule, :language => @de,
                           :conditions => [["is", ["bar"]]])
    
    @t1 = Factory.create(:translation, :language => @de, :phrase => @phrase)
    @t2 = Factory.create(:translation, :language => @de, :phrase => @phrase)
    @tfoo = Factory.create(:translation, :language => @de, :phrase => @phrase,
                         :rules => [rule1.id])
    @tbar = Factory.create(:translation, :language => @de, :phrase => @phrase,
                         :rules => [rule2.id])
  end

  it "should find translations for 'is foo'" do
    t = Otwtranslation::Translation.for_context(@phrase.label,
                                                @de, {:name => "foo"})
    t.size.should == 3
    t.should include(@t1)
    t.should include(@t2)
    t.should include(@tfoo)
  end

  it "should find translations for 'is bar'" do
    t = Otwtranslation::Translation.for_context(@phrase.label,
                                                @de, {:name => "bar"})
    t.size.should == 3
    t.should include(@t1)
    t.should include(@t2)
    t.should include(@tbar)
  end

  it "should find translations for no specific rule" do
    t = Otwtranslation::Translation
      .for_context(@phrase.label, @de, {:name => "blah"})
    t.size.should == 2
    t.should include(@t1)
    t.should include(@t2)
  end

end
