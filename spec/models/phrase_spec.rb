require 'spec_helper'

describe Otwtranslation::Phrase, "creation" do
  
  it "should create a new phrase" do
    source = {:controller => "works", :action => "show", :url => "works/1"}
    phrase = Otwtranslation::Phrase.find_or_create("foo", "bar", source)
    phrase = Otwtranslation::Phrase.find(phrase.id)
    phrase.label.should == "foo"
    phrase.description.should == "bar"
    phrase.sources.first.controller.should == "works"
    phrase.sources.first.action.should == "show"
    phrase.sources.first.url.should == "works/1"
    phrase.version.should == OtwtranslationConfig.VERSION
  end

  it "should add a second source" do
    source = {:controller => "works", :action => "show", :url => "works/1"}
    phrase = Otwtranslation::Phrase.find_or_create("foo", "bar", source)
    source = {:controller => "works", :action => "index", :url => "works/"}
    phrase = Otwtranslation::Phrase.find_or_create("foo", "bar", source)
    phrase.sources.count.should == 2
  end

  it "should create the same phrase only once" do
    phrase1 = Otwtranslation::Phrase.find_or_create("foo")
    phrase2 = Otwtranslation::Phrase.find_or_create("foo")
    phrase1.id.should == phrase2.id
  end

  it "should create two phrases when descriptions differ" do
    phrase1 = Otwtranslation::Phrase.find_or_create("foo", "bar")
    phrase2 = Otwtranslation::Phrase.find_or_create("foo", "baz")
    phrase1.id.should_not == phrase2.id
    phrase1.description.should == "bar"
    phrase2.description.should == "baz"
  end
end

describe Otwtranslation::Phrase, "update" do
  
  it "should update version" do
    OtwtranslationConfig.VERSION = "1.0"
    Otwtranslation::Phrase.find_or_create("foo")
    OtwtranslationConfig.VERSION = "1.1"
    phrase = Otwtranslation::Phrase.find_or_create("foo")
    phrase.version.should == "1.1"
    Otwtranslation::Phrase.find(phrase.id).version.should == "1.1"
  end

  it "should cache" do
    source = {:controller => "works", :action => "show", :url => "works/1"}
    phrase = Otwtranslation::Phrase.find_or_create("foo", "bar", source)
    Otwtranslation::Phrase.should_not_receive(:find_or_create_by_key)
    source = {:controller => "works", :action => "show", :url => "works/2"}
    phrase = Otwtranslation::Phrase.find_or_create("foo", "bar", source)
  end
end

  
describe Otwtranslation::Phrase, "translation associations" do
   before(:each) do
    @de = Factory.create(:language, :name => "Deutsch")
    @nl = Factory.create(:language, :name => "Nederlands")
    @phrase = Factory.create(:phrase, :label => "{possessive::name}")
    
    Factory.create(:translation, :language => @de, :phrase => @phrase)
    Factory.create(:translation, :language => @de, :phrase => @phrase,
                   :approved => true)
    
    Factory.create(:translation, :language => @nl, :phrase => @phrase)
    Factory.create(:translation, :language => @nl, :phrase => @phrase,
                   :approved => true)
  end

  it "should find all translations" do
    @phrase.translations.size.should == 4
  end
  
  it "should find all translations per language" do
    @phrase.translations_for(@de.short).size.should == 2
    @phrase.translations_for(@de.short).first.language_short == @de.short
    @phrase.translations_for(@de.short).last.language_short == @de.short
    @phrase.translations_for(@nl.short).size == 2
    @phrase.translations_for(@nl.short).first.language_short == @nl.short
    @phrase.translations_for(@nl.short).last.language_short == @nl.short
  end
  
  it "should find approved translations per language" do
    @phrase.approved_translations_for(@de.short).size.should == 1
    t = @phrase.approved_translations_for(@de.short).first
    t.language_short.should == @de.short
    t.approved.should == true

    @phrase.approved_translations_for(@nl.short).size.should == 1
    t = @phrase.approved_translations_for(@nl.short).first
    t.language_short.should == @nl.short
    t.approved.should == true
  end

  it "should find translations per language per rule" do
    rule1 = Factory.create(:possessive_rule, :language => @de,
                           :conditions => [["is", ["foo"]]])
    rule2 = Factory.create(:possessive_rule, :language => @de,
                           :conditions => [["is", ["bar"]]])
    
    Factory.create(:translation, :language => @de, :phrase => @phrase,
                   :rules => [rule1.id])
    Factory.create(:translation, :language => @de, :phrase => @phrase,
                   :rules => [rule2.id])

    @phrase.translations_for(@de.short, {:name => "foo"}).size.should == 3
    t = @phrase.translations_for(@de.short, {:name => "foo"}).first
    t.language_short.should == @de.short
    t.rules.should == [rule1.id]
    
    @phrase.translations_for(@de.short, {:name => "bar"}).size.should == 3
    t = @phrase.translations_for(@de.short, {:name => "bar"}).first
    t.language_short.should == @de.short
    t.rules.should == [rule2.id]
    
    @phrase.translations_for(@de.short, {:name => "blah"}).size.should == 2

  end
  
end
