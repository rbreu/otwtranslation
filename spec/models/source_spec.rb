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


end
