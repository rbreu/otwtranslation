require 'spec_helper'

describe Otwtranslation::Language do

  it "should save a new language" do
    language = Otwtranslation::Language.new()
    language.short = "de"
    language.name = "Deutsch"
    language.right_to_left = false
    language.translation_visible = true
    language.save!
    language.short.should == "de"
    language.name.should == "Deutsch"
    language.right_to_left.should be_false
    language.translation_visible.should be_true
  end

  context "when there are languages, phrases and sources" do

    before(:each) do
      @german = FactoryGirl.create(:language, :name => "Deutsch")
      @dutch = FactoryGirl.create(:language, :name => "Nederlands")
      
      @source1 = FactoryGirl.create(:source)
      @phrase1 = FactoryGirl.create(:phrase)
      @phrase1.sources << @source1

      @source2 = FactoryGirl.create(:source)
      @phrase2 = FactoryGirl.create(:phrase)
      @phrase2.sources << @source2
    end
    
    it "stats should return 0% for 0 translations" do
      @german.percentage_translated.should  be_within(0.00001).of(0)
      @german.percentage_approved.should be_within(0.00001).of(0)
    end

    it "stats should count translations in the current language" do
      FactoryGirl.create(:translation,
                         {:language => @german, :phrase => @phrase1})
      @german.percentage_translated.should be_within(0.00001).of(50)
      @german.percentage_approved.should be_within(0.00001).of(0)
    end
    
    it "stats should count approved translations in the current language" do
      FactoryGirl.create(:translation,
                         {:language => @german, :phrase => @phrase1,
                           :approved => true})
      @german.percentage_translated.should be_within(0.00001).of(50)
      @german.percentage_approved.should be_within(0.00001).of(50)
    end

    it "stats should not count translations for other languages" do
      FactoryGirl.create(:translation,
                         {:language => @german, :phrase => @phrase1,
                           :approved => true})
      @dutch.percentage_translated.should be_within(0.00001).of(0)
      @dutch.percentage_approved.should be_within(0.00001).of(0)
    end

    it "stats should not count multiple translations for one phrase" do
       FactoryGirl.create(:translation,
                          {:language => @german, :phrase => @phrase1,
                            :approved => true})
       FactoryGirl.create(:translation,
                          {:language => @german, :phrase => @phrase1})
     
      @german.percentage_translated.should be_within(0.00001).of(50)
      @german.percentage_approved.should be_within(0.00001).of(50)
    end


    it "stats should count translations of multiple phrases" do
      FactoryGirl.create(:translation,
                         {:language => @german, :phrase => @phrase1,
                           :approved => true})
   
      FactoryGirl.create(:translation,
                         {:language => @german, :phrase => @phrase2,
                           :approved => true})
      
      @german.percentage_translated.should be_within(0.00001).of(100)
      @german.percentage_approved.should be_within(0.00001).of(100)

    end
   
  end

end
