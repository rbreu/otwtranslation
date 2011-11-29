require 'spec_helper'


describe Otwtranslation::ParameterParser, "tokenize" do

  it "should parse single quoted parameter" do
    Otwtranslation::ParameterParser.tokenize('').should == []
  end
  
  it "should parse single quoted parameter" do
    Otwtranslation::ParameterParser.tokenize('"aa"').should == ["aa"]
    Otwtranslation::ParameterParser.tokenize('"aa",').should == ["aa"]
    Otwtranslation::ParameterParser.tokenize('"aa", ').should == ["aa"]
  end

  it "should parse single non-quoted parameter" do
    Otwtranslation::ParameterParser.tokenize('aa').should == ["aa"]
    Otwtranslation::ParameterParser.tokenize('aa,').should == ["aa"]
    Otwtranslation::ParameterParser.tokenize('aa, ').should == ["aa"]
  end

  it "should parse simple quoted parameter list" do
    Otwtranslation::ParameterParser.tokenize('"aa","bb", "cc" , "dd"')
      .should == ["aa", "bb", "cc", "dd"]
  end

  it "should parse simple non-quoted parameter list" do
    Otwtranslation::ParameterParser.tokenize('aa,bb, cc , dd')
      .should == ["aa", "bb", "cc", "dd"]
  end

  it "should parse mixed non-quoted/quoted parameter list" do
    Otwtranslation::ParameterParser.tokenize('aa,"bb", cc')
      .should == ["aa", "bb", "cc"]
  end

  it "should parse quoted parameters with commas" do
    Otwtranslation::ParameterParser.tokenize('"aa", "b,b,b", cc')
      .should == ["aa", "b,b,b", "cc"]
    Otwtranslation::ParameterParser.tokenize('"aa", "b, b, b", cc')
      .should == ["aa", "b, b, b", "cc"]
  end

  it "should ignore leading/trailing spaces for unquoted params" do
    Otwtranslation::ParameterParser.tokenize(' aa ,  bb, cc ')
      .should == ["aa", "bb", "cc"]
  end

  it "should not ignore leading/traling spaces inside quoted" do
    Otwtranslation::ParameterParser.tokenize('" aa ","  bb"," cc "')
      .should == [" aa ", "  bb", " cc "]
  end

  it "should remove HTML" do
    Otwtranslation::ParameterParser.tokenize('<em>a</em>, b')
      .should == ["a", "b"]
  end
end

describe Otwtranslation::ParameterParser, "stringify" do

  it "should not quote simple parameters" do
    Otwtranslation::ParameterParser.stringify(["aa", "b b", "cc"])
      .should == 'aa, b b, cc'
  end

  it "should quote commas" do
    Otwtranslation::ParameterParser.stringify(["aa", "b,b", "cc"])
      .should == 'aa, "b,b", cc'
  end
  
  it "should quote leading spaces" do
    Otwtranslation::ParameterParser.stringify(["aa", " bb", "cc"])
      .should == 'aa, " bb", cc'
  end
  
  it "should quote trailing spaces" do
    Otwtranslation::ParameterParser.stringify(["aa", " bb", "cc"])
      .should == 'aa, " bb", cc'
  end
end
