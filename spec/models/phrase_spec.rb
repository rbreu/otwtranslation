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
    phrase.locale.should == OtwtranslationConfig.DEFAULT_LOCALE
    phrase.version.should == OtwtranslationConfig.VERSION
  end

  it "should add a second source" do
    source = {:controller => "works", :action => "show", :url => "works/1"}
    phrase = Otwtranslation::Phrase.find_or_create("foo", "bar", source)
    source = {:controller => "works", :action => "index", :url => "works/"}
    phrase = Otwtranslation::Phrase.find_or_create("foo", "bar", source)
    phrase.sources.count.should == 2
  end

  it "should cache" do
    source = {:controller => "works", :action => "show", :url => "works/1"}
    phrase = Otwtranslation::Phrase.find_or_create("foo", "bar", source)
    Otwtranslation::Phrase.should_not_receive(:find_or_create_by_key)
    source = {:controller => "works", :action => "show", :url => "works/2"}
    phrase = Otwtranslation::Phrase.find_or_create("foo", "bar", source)
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

end


