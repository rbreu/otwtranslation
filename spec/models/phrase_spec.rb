require 'spec_helper'

describe Otwtranslation::Phrase, "creation" do
  before(:each) do
    Rails.cache.clear
  end
  
  it "should create a new phrase" do
    source = {:controller => "user", :action => "show", :url => "user/1"}
    phrase = Otwtranslation::Phrase.find_or_create("foo", "bar", source)
    phrase = Otwtranslation::Phrase.find(phrase.id)
    phrase.label.should == "foo"
    phrase.description.should == "bar"
    phrase.source.controller.should == "user"
    phrase.source.action.should == "show"
    phrase.source.url.should == "user/1"
    phrase.locale.should == OtwtranslationConfig.DEFAULT_LOCALE
    phrase.version.should == OtwtranslationConfig.VERSION
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
  before(:each) do
    Rails.cache.clear
  end
  
  it "should update version" do
    OtwtranslationConfig.VERSION = "1.0"
    Otwtranslation::Phrase.find_or_create("foo")
    OtwtranslationConfig.VERSION = "1.1"
    phrase = Otwtranslation::Phrase.find_or_create("foo")
    phrase.version.should == "1.1"
    Otwtranslation::Phrase.find(phrase.id).version.should == "1.1"
  end

end


