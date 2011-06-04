require 'spec_helper'


describe Otwtranslation::ParameterParser, "tokenize" do

  it "should parse single quoted parameter" do
    Otwtranslation::ParameterParser.tokenize('').should == []
  end
  
  it "should parse single quoted parameter" do
    Otwtranslation::ParameterParser.tokenize('"my"').should == ["my"]
    Otwtranslation::ParameterParser.tokenize('"my",').should == ["my"]
    Otwtranslation::ParameterParser.tokenize('"my", ').should == ["my"]
  end

  it "should parse single non-quoted parameter" do
    Otwtranslation::ParameterParser.tokenize('my').should == ["my"]
    Otwtranslation::ParameterParser.tokenize('my,').should == ["my"]
    Otwtranslation::ParameterParser.tokenize('my, ').should == ["my"]
  end

  it "should parse simple quoted parameter list" do
    Otwtranslation::ParameterParser.tokenize('"my","jet", "now"')
      .should == ["my", "jet", "now"]
  end

  it "should parse simple non-quoted parameter list" do
    Otwtranslation::ParameterParser.tokenize('my,jet, now')
      .should == ["my", "jet", "now"]
  end

  it "should parse mixed non-quoted/quoted parameter list" do
    Otwtranslation::ParameterParser.tokenize('my,"jet", now')
      .should == ["my", "jet", "now"]
  end

  it "should parse quoted parameters with commas" do
    Otwtranslation::ParameterParser.tokenize('"my", "j,e,t", now')
      .should == ["my", "j,e,t", "now"]
  end

    
end

