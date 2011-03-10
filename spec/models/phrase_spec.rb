require 'spec_helper'

describe Otwtranslation::Phrase, "creation" do
  before(:each) do
    Rails.cache.clear
  end
  
  it "should create a new phrase" do
    phrase = Otwtranslation::Phrase.find_or_create("foo")
    phrase.label.should == "foo"
    phrase.description.should == ""
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

  it "should update version" do
    OtwtranslationConfig.VERSION = "1.0"
    Otwtranslation::Phrase.find_or_create("foo")
    OtwtranslationConfig.VERSION = "1.1"
    phrase = Otwtranslation::Phrase.find_or_create("foo")
    phrase.version.should == "1.1"
    Otwtranslation::Phrase.find(phrase.id).version.should == "1.1"
  end
end

describe Otwtranslation::Phrase, "sources" do
  before(:each) do
    key, cache_key = Otwtranslation::Phrase.generate_keys("foo")
    @phrase = Otwtranslation::Phrase.create(:label => "foo", :key => key)
  end
  
  it "should add a source" do
    @phrase.add_source("home", "index", "/home/index")
    source = @phrase.sources.find_by_controller("home")
    source.controller.should == "home"
    source.action.should == "index"
  end

  it "should add a source only once" do
    @phrase.add_source("home", "index", "/home/index/1")
    @phrase.add_source("home", "index", "/home/index/2")
    @phrase.sources.count.should == 1
  end

  it "should only keep MAX_SOURCES_PER_PHRASE latest sources" do
    max = OtwtranslationConfig.MAX_SOURCES_PER_PHRASE.to_i
    (max + 2).times do |i|
      @phrase.add_source("home#{i}#index", "/home#{i}/index")
    end
    
    @phrase.sources.all.count.should == max
    @phrase.sources.find_by_controller("home0").should equal nil
    @phrase.sources.find_by_controller("home1").should equal nil
  end
end
  
describe Otwtranslation::Phrase, "deletion" do
  
  it "should remove orphaned sources" do
    key, cache_key = Otwtranslation::Phrase.generate_keys("foo")
    phrase = Otwtranslation::Phrase.create(:label => "foo", :key => key)
    phrase.add_source("home", "index", "/home/index")
    phrase.destroy
    source = Otwtranslation::Source.find_by_controller("home")
    source.should equal nil
  end

  it "should not remove used sources" do
    key, cache_key = Otwtranslation::Phrase.generate_keys("foo")
    phrase1 = Otwtranslation::Phrase.create(:label => "foo", :key => key)
    phrase1.add_source("home", "index", "/home/index")
    
    key, cache_key = Otwtranslation::Phrase.generate_keys("bar")
    phrase2 = Otwtranslation::Phrase.create(:label => "bar", :key => key)
    phrase2.add_source("home", "index", "/home/index")

    phrase1.destroy
    source = Otwtranslation::Source.find_by_controller("home")
    source.should_not equal nil
  end

end

