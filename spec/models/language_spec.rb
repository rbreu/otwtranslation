require 'spec_helper'

describe Otwtranslation::Language do

  it "should create a new language" do
    language = Otwtranslation::Language.create(:short => "de",
                                               :name => "Deutsch", 
                                               :right_to_left => false,
                                               :translation_visible => true)
    language.short.should == "de"
    language.name.should == "Deutsch"
    language.right_to_left.should == false
    language.translation_visible.should == true
  end

end
