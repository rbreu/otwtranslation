require 'spec_helper'

describe Otwtranslation::Dummy do

  before(:each) do
    @dummy = Otwtranslation::Dummy.new
  end
  
  it "should return itself for unknown methods" do
    @dummy.foo.should == @dummy
    @dummy.foo.bar.baz.should == @dummy
  end

  it "should return DUMMY for to_s" do
    @dummy.to_s.should == "DUMMY"
  end

  it "should return DUMMY for gsub" do
    @dummy.gsub.should == "DUMMY"
  end

end
