require 'spec_helper'

describe OtwtranslationHelper do

  describe "ts" do
    it "should return the original phrase" do
      helper.stub(:logged_in?).and_return(false)
      helper.ts("Good day!").should == "Good day!"
    end

    it "should substitute tokens" do
      helper.stub(:logged_in?).and_return(false)
      helper.ts("Hello {data::name}!", "", :name => "Abby")
        .should == "Hello Abby!"
    end
  end

  describe "t" do
    it "should return the original phrase" do
      t("home.greeting", :default => "Good day!").should == "Good day!"
    end

    it "should insert variables" do
      t("home.greeting", :default => "Good day, %{name}!",
               :name => "Abby").should == "Good day, Abby!"
    end
  end


  describe "otwtranslation_decorated_translation" do
    before(:each) do
      @phrase = Factory.create(:phrase, :label => "Good day!")
      helper.stub(:otwtranslation_language).and_return("de")
    end
    
    it "should mark the phrase untranslated" do
      otwtranslation_decorated_translation(@phrase.key)
        .should == "<span id=\"otwtranslation_phrase_#{@phrase.key}\" class=\"untranslated\"><span class=\"landmark\">translate</span>*Good day!</span>"
    end
      
    it "should mark the phrase translated" do
      translation = Factory.create(:translation,
                                   :label => "Guten Tag!",
                                   :language_short => "de",
                                   :approved => false,
                                   :phrase => @phrase)

      helper.otwtranslation_decorated_translation(@phrase.key)
        .should == "<span id=\"otwtranslation_phrase_#{@phrase.key}\" class=\"translated\"><span class=\"landmark\">review</span>Guten Tag!</span>"
      
    end
    
    it "should mark the phrase approved" do
      translation = Factory.create(:translation,
                                   :label => "Moin!",
                                   :language_short => "de",
                                   :approved => true,
                                   :phrase => @phrase)
      
      helper.otwtranslation_decorated_translation(@phrase.key)
        .should == "<span id=\"otwtranslation_phrase_#{@phrase.key}\" class=\"approved\">Moin!</span>"
    end
    
    it "should cache all text labels" do
      otwtranslation_decorated_translation(@phrase.key)
      Otwtranslation::Phrase.should_not_receive(:find_by_key)
      otwtranslation_decorated_translation(@phrase.key).should == "<span id=\"otwtranslation_phrase_#{@phrase.key}\" class=\"untranslated\"><span class=\"landmark\">translate</span>*Good day!</span>"
    end
    
    it "should not cache labe with rules" do
      @phrase = Factory.create(:phrase, :label => "Hello {data::name}!")

      otwtranslation_decorated_translation(@phrase.key)
      Rails.cache.should_not_receive(:write)
      otwtranslation_decorated_translation(@phrase.key)
    end
  end

end
