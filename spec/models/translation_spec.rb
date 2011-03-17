require 'spec_helper'

describe Otwtranslation::Translation do

  it "should create a new translation" do
    translation = Otwtranslation::Translation.new(:label => "irgendwas",
                                                  :approved => false)
    translation.language = mock_model(Otwtranslation::Language)
    translation.phrase  = mock_model(Otwtranslation::Phrase)
    translation.save.should == true

    translation = Otwtranslation::Translation.first
    translation.label.should == "irgendwas"
    translation.approved.should == false
  end

end
