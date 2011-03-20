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

  context "when there are languages, phrases and sources" do

    before(:each) do
      @german = Factory.create(:language, :name => "Deutsch")
      @dutch = Factory.create(:language, :name => "Nederlands")
      
      @source1 = Factory.create(:source)
      @phrase1 = Factory.create(:phrase)
      @phrase1.sources << @source1

      @source2 = Factory.create(:source)
      @phrase2 = Factory.create(:phrase)
      @phrase2.sources << @source2
    end
    
    it "stats should return 0% for 0 translations" do
      @german.percentage_translated.should  be_within(0.00001).of(0)
      @german.percentage_approved.should be_within(0.00001).of(0)
    end

    it "stats should count translations in the current language" do
      Factory.create(:translation, {:language => @german, :phrase => @phrase1})
      @german.percentage_translated.should be_within(0.00001).of(50)
      @german.percentage_approved.should be_within(0.00001).of(0)
    end
    
    it "stats should count approved translations in the current language" do
      Factory.create(:translation,
                     {:language => @german, :phrase => @phrase1, :approved => true})
      @german.percentage_translated.should be_within(0.00001).of(50)
      @german.percentage_approved.should be_within(0.00001).of(50)
    end

    it "stats should not count translations for other languages" do
      Factory.create(:translation,
                     {:language => @german, :phrase => @phrase1, :approved => true})
      @dutch.percentage_translated.should be_within(0.00001).of(0)
      @dutch.percentage_approved.should be_within(0.00001).of(0)
    end

    it "stats should not count multiple translations for one phrase" do
       Factory.create(:translation,
                      {:language => @german, :phrase => @phrase1, :approved => true})
       Factory.create(:translation,
                      {:language => @german, :phrase => @phrase1, :approved => true})
     
      @german.percentage_translated.should be_within(0.00001).of(50)
      @german.percentage_approved.should be_within(0.00001).of(50)
    end


    it "stats should count translations of multiple phrases" do
      Factory.create(:translation,
                     {:language => @german, :phrase => @phrase1, :approved => true})
   
      Factory.create(:translation,
                     {:language => @german, :phrase => @phrase2, :approved => true})
      
      @german.percentage_translated.should be_within(0.00001).of(100)
      @german.percentage_approved.should be_within(0.00001).of(100)

    end
   
  end

end
