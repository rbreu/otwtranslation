require 'spec_helper'

describe Otwtranslation::Translation do

  before(:each) do
    @language = FactoryGirl.create(:language)
    @phrase = FactoryGirl.create(:phrase)
    @language2 = FactoryGirl.create(:language)
    @phrase2 = FactoryGirl.create(:phrase)
  end

  it "should create a new translation" do
    translation = Otwtranslation::Translation.new()
    translation.label = "irgendwas"
    translation.language = @language
    translation.phrase = @phrase
    translation.approved = false
    
    translation.save!
    translation.rules.should == []
  end

  it "should let basic inline HTML untouched" do
    translation = Otwtranslation::Translation.new()
    translation.label = "<em>foo</em><strong>bar</strong>"
    translation.language = @language
    translation.phrase = @phrase

    translation.save!
    translation.label.should == "<em>foo</em><strong>bar</strong>"
  end

  it "should remove unknown HTML tags" do
    translation = Otwtranslation::Translation.new()
    translation.label = "<blah>foo</blah><a>bar</a>"
    translation.language = @language
    translation.phrase = @phrase

    translation.save!
    translation.label.should == "foobar"
  end
  
  it "should handle wrong HTML" do
    translation = Otwtranslation::Translation.new()
    translation.label = "<em>hello</i>"
    translation.locale = "de"
    translation.language = @language
    translation.phrase = @phrase

    translation.save!
    translation.label.should == "<em>hello</em>"
  end
  
  it "should handle missing end tags" do
    translation = Otwtranslation::Translation.new()
    translation.label = "<em>hello"
    translation.locale = "de"
    translation.language = @language
    translation.phrase = @phrase

    translation.save!
    translation.label.should == "<em>hello</em>"
  end

  
  it "should allow an approved translation" do
    translation = Otwtranslation::Translation.new()
    translation.label = "irgendwas"
    translation.language = @language
    translation.phrase = @phrase
    translation.approved = true

    translation.save!
  end

  it "should not allow approved translation if unspecific approved translation exists" do
    FactoryGirl.create(:translation,
                       :label => "irgendwas",
                       :language => @language,
                       :phrase => @phrase, 
                       :approved => true)
    translation = Otwtranslation::Translation.new()
    translation.label = "irgendwas"
    translation.language = @language
    translation.phrase = @phrase
    translation.approved = true
    translation.rules = [1]

    translation.save.should be_false
    translation.errors[:approved].should == ["Another translation is already approved."]
    
  end

  it "should allow two approved translations for two different rules" do
    FactoryGirl.create(:translation,
                       :label => "irgendwas",
                       :language => @language,
                       :phrase => @phrase,
                       :approved => true,
                       :rules => [1])
    translation = Otwtranslation::Translation.new()
    translation.label = "irgendwas"
    translation.language = @language
    translation.phrase = @phrase
    translation.approved = true
    translation.rules = [2]

    translation.save!
  end

  it "should not allow two approved translations for the same rules" do
    FactoryGirl.create(:translation,
                       :label => "irgendwas",
                       :language => @language,
                       :phrase => @phrase,
                       :approved => true,
                       :rules => [1])
    translation = Otwtranslation::Translation.new()
    translation.label = "irgendwas"
    translation.language = @language
    translation.phrase = @phrase
    translation.approved = true
    translation.rules = [1]

    translation.save.should be_false
    translation.errors[:approved].should == ["Another translation is already approved."]
   
  end

  it "should allow two approved translations for different languages" do
    FactoryGirl.create(:translation,
                       :label => "irgendwas",
                       :language => @language,
                       :phrase => @phrase,
                       :approved => true)
    translation = Otwtranslation::Translation.new()
    translation.label = "irgendwas"
    translation.language = @language2
    translation.phrase = @phrase
    translation.approved = true

    translation.save!
  end

  it "should allow two approved translations for different phrases" do
    FactoryGirl.create(:translation,
                       :label => "irgendwas",
                       :language => @language,
                       :phrase => @phrase,
                       :approved => true)
    translation = Otwtranslation::Translation.new()
    translation.label = "irgendwas"
    translation.language = @language
    translation.phrase = @phrase2
    translation.approved = true

    translation.save!
  end

end

describe Otwtranslation::Translation, "for_language" do
   before(:each) do
    @de = FactoryGirl.create(:language, :name => "Deutsch")
    @nl = FactoryGirl.create(:language, :name => "Nederlands")
    @phrase = FactoryGirl.create(:phrase)
    
    FactoryGirl.create(:translation, :language => @de, :phrase => @phrase)
    FactoryGirl.create(:translation, :language => @de, :phrase => @phrase)
    FactoryGirl.create(:translation, :language => @nl, :phrase => @phrase)
  end

  it "should find german translations" do
    t = Otwtranslation::Translation.for_language(@de)
    t.size.should == 2
    t.first.locale.should == @de.locale
    t.last.locale.should == @de.locale
    t.should == Otwtranslation::Translation.for_language(@de.locale)

  end

  it "should find dutch translations" do
    t = Otwtranslation::Translation.for_language(@nl)
    t.size.should == 1
    t.first.locale.should == @nl.locale
    t.should == Otwtranslation::Translation.for_language(@nl.locale)
  end
end


describe Otwtranslation::Translation, "for_context" do
   before(:each) do
    @de = FactoryGirl.create(:language, :name => "Deutsch")
    @phrase = FactoryGirl.create(:phrase, :label => "{possessive::name}")
    @phrase2 = FactoryGirl.create(:phrase, :label => "{possessive::name} apple")
    rule1 = FactoryGirl.create(:possessive_rule, :language => @de,
                               :conditions => [["is", ["foo"]]])
    rule2 = FactoryGirl.create(:possessive_rule, :language => @de,
                               :conditions => [["is", ["bar"]]])
    
    @t1 = FactoryGirl.create(:translation, :language => @de, :phrase => @phrase)
    @t2 = FactoryGirl.create(:translation, :language => @de, :phrase => @phrase)
    @t3 = FactoryGirl.create(:translation, :language => @de, :phrase => @phrase2)
    @tfoo = FactoryGirl.create(:translation, :language => @de,
                               :phrase => @phrase,
                               :rules => [rule1.id])
    @tbar = FactoryGirl.create(:translation, :language => @de,
                               :phrase => @phrase,
                               :rules => [rule2.id])
  end

  it "should find translations for 'is foo'" do
    t = Otwtranslation::Translation.for_context(@phrase.key, @phrase.label,
                                                @de, {:name => "foo"})
    t.size.should == 3
    t.should include(@t1)
    t.should include(@t2)
    t.should include(@tfoo)
  end

  it "should find translations for 'is bar'" do
    t = Otwtranslation::Translation.for_context(@phrase.key, @phrase.label,
                                                @de, {:name => "bar"})
    t.size.should == 3
    t.should include(@t1)
    t.should include(@t2)
    t.should include(@tbar)
  end

  it "should find translations for no specific rule" do
    t = Otwtranslation::Translation
      .for_context(@phrase.key, @phrase.label, @de, {:name => "blah"})
    t.size.should == 2
    t.should include(@t1)
    t.should include(@t2)
  end

  it "should find all translations when no variables are given" do
    t = Otwtranslation::Translation.for_context(@phrase.key, @phrase.label,
                                                @de, {})
    t.size.should == 4
    t.should include(@t1)
    t.should include(@t2)
    t.should include(@tfoo)
    t.should include(@tbar)
  end

end


describe Otwtranslation::Translation, "approved_label_for_context" do
   before(:each) do
    @de = FactoryGirl.create(:language, :name => "Deutsch")
    @phrase = FactoryGirl.create(:phrase, :label => "{possessive::name}")
    @phrase2 = FactoryGirl.create(:phrase, :label => "{possessive::name} apple")
    @rule1 = FactoryGirl.create(:possessive_rule, :language => @de,
                                :conditions => [["is", ["foo"]]])
    @rule2 = FactoryGirl.create(:possessive_rule, :language => @de,
                                :conditions => [["is", ["bar"]]])
    
    FactoryGirl.create(:translation, :language => @de, :phrase => @phrase2,
                       :approved => "true")
  end

  it "should find context-unaware translations for 'is foo'" do
    t = FactoryGirl.create(:translation, :language => @de, :phrase => @phrase,
                           :approved => "true")
    
    Otwtranslation::Translation
      .approved_label_for_context(@phrase.key, @phrase.label, @de, {:name => "foo"})
      .should == t.label
  end

  it "should find context-aware translations for 'is foo'" do
    tfoo = FactoryGirl.create(:translation,
                              :language => @de,
                              :phrase => @phrase,
                              :approved => "true",
                              :rules => [@rule1.id])
    tbar = FactoryGirl.create(:translation,
                              :language => @de,
                              :phrase => @phrase,
                              :approved => "true",
                              :rules => [@rule2.id])
    
    Otwtranslation::Translation
      .approved_label_for_context(@phrase.key, @phrase.label, @de, {:name => "foo"})
      .should == tfoo.label
  end

  it "should not find translations that have been disapproved" do
    t = FactoryGirl.create(:translation, :language => @de, :phrase => @phrase,
                           :approved => "true")
    t.approved = false
    t.save

    Otwtranslation::Translation
      .approved_label_for_context(@phrase.key, @phrase.label, @de, {:name => "foo"})
      .should be_nil
  end



end

