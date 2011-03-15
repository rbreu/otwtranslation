require 'spec_helper'

describe Language do

  it "should create a new language" do
    language = Language.create(:short => "de",
                               :name => "Deutsch", 
                               :right_to_left => false,
                               :translation_viewable => true)
    language.short.should == "de"
    language.name.should == "Deutsch"
    language.right_to_left.should == false
    language.translation_viewable.should == true
  end

end
