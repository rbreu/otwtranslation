require 'spec_helper'

describe Otwtranslation::Source do
  it "should create a new source" do
    source = Otwtranslation::Source.find_or_create("home#index", "www.bla/home")
    source.controller.should == "home#index"
    source.uri.should == "www.bla/home"
  end


end
