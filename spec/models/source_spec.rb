require 'spec_helper'

describe Otwtranslation::Source do

  it "should create a new source" do
    source = Otwtranslation::Source.find_or_create(:controller => "home",
                                                   :action => "index",
                                                   :url => "www.bla/home")
    source.controller.should == "home"
    source.action.should == "index"
    source.url.should == "www.bla/home"
  end

  it "should not create the same controller/action twice" do
    source1 = Otwtranslation::Source.find_or_create(:controller => "home",
                                                    :action => "index")
    source2 = Otwtranslation::Source.find_or_create(:controller => "home",
                                                    :action => "index")
    source1.id.should == source2.id
  end

  it "should create two sources when action differs" do
    source1 = Otwtranslation::Source.find_or_create(:controller => "home",
                                                    :action => "index")
    source2 = Otwtranslation::Source.find_or_create(:controller => "home",
                                                    :action => "show")
    source1.id.should_not == source2.id
  end

  it "should return true when there are phrases with current version" do
    OtwtranslationConfig.VERSION = '1.0'
    source = {:controller => "test", :action => "me"}
    phrase = Otwtranslation::Phrase.find_or_create("Hello", "", source)

    OtwtranslationConfig.VERSION = '1.1'
    phrase = Otwtranslation::Phrase.find_or_create("Hi hi", "", source)
    phrase.source.has_phrases_with_current_verion?.should equal true
  end
  
  it "should return false when there are no phrases with current version" do
    OtwtranslationConfig.VERSION = '1.0'
    source = {:controller => "test", :action => "me"}
    phrase = Otwtranslation::Phrase.find_or_create("Hello", "", source)
    
    OtwtranslationConfig.VERSION = '1.1'
    phrase.source.has_phrases_with_current_verion?.should equal false
  end

end
