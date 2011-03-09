require 'spec_helper'

describe Otwtranslation::Source do
  it "should create a new source" do
    source = Otwtranslation::Source.find_or_create("home", "index",
                                                   "www.bla/home")
    source.controller.should == "home"
    source.action.should == "index"
    source.url.should == "www.bla/home"
  end

  it "should not create the same controller twice" do
    source1 = Otwtranslation::Source.find_or_create("home", "index")
    source2 = Otwtranslation::Source.find_or_create("home", "index")
    source1.id.should == source2.id
  end


end
