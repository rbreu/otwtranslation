require 'spec_helper'

describe Otwtranslation::Source do

  it "should create a new source" do
    source = Otwtranslation::Source.find_or_create(:controller => "home",
                                                   :action => "index",
                                                   :url => "www.bla/home")
    source.controller.should == "home"
    source.action.should == "index"
    source.url.should == "www.bla/home"
  end

  it "should not create the same controller/action twice" do
    source1 = Otwtranslation::Source.find_or_create(:controller => "home",
                                                    :action => "index")
    source2 = Otwtranslation::Source.find_or_create(:controller => "home",
                                                    :action => "index")
    source1.id.should == source2.id
  end

  it "should create two sources when action differs" do
    source1 = Otwtranslation::Source.find_or_create(:controller => "home",
                                                    :action => "index")
    source2 = Otwtranslation::Source.find_or_create(:controller => "home",
                                                    :action => "show")
    source1.id.should_not == source2.id
  end

  it "should return true when there are phrases with current version" do
    OtwtranslationConfig.VERSION = '1.0'
    source = {:controller => "test", :action => "me"}
    phrase = Otwtranslation::Phrase.find_or_create("Hello", "", source)
    OtwtranslationConfig.VERSION = '1.1'
    phrase = Otwtranslation::Phrase.find_or_create("Hi hi", "", source)

    source = Otwtranslation::Source.find_by_source(source)
    source.has_phrases_with_current_verion?.should equal true
  end
  
  it "should return false when there are no phrases with current version" do
    OtwtranslationConfig.VERSION = '1.0'
    source = {:controller => "test", :action => "me"}
    phrase = Otwtranslation::Phrase.find_or_create("Hello", "", source)
    OtwtranslationConfig.VERSION = '1.1'

    source = Otwtranslation::Source.find_by_source(source)
    source.has_phrases_with_current_verion?.should equal false
  end

  context "when there are languages, phrases and sources" do

    before(:each) do
      @german = Factory.create(:language, :name => "Deutsch")
      @dutch = Factory.create(:language, :name => "Nederlands")
      
      @source = Factory.create(:source)
      
      @phrase1 = Factory.create(:phrase)
      @phrase1.sources << @source
      @phrase2 = Factory.create(:phrase)
      @phrase2.sources << @source
    end
    
    it "stats should return 0% for 0 translations" do
      @source.percentage_translated_for(@german.short).should \
      be_within(0.00001).of(0)

      @source.percentage_approved_for(@german.short).should \
      be_within(0.00001).of(0)
    end

    it "stats should count translations in the current language" do
      Factory.create(:translation, {:language => @german, :phrase => @phrase1})
      @source.percentage_translated_for(@german.short).should \
      be_within(0.00001).of(50)

      @source.percentage_approved_for(@german.short).should \
      be_within(0.00001).of(0)
    end
    
    it "stats should count approved translations in the current language" do
      Factory.create(:translation,
                     {:language => @german, :phrase => @phrase1, :approved => true})
      @source.percentage_translated_for(@german.short).should \
      be_within(0.00001).of(50)

      @source.percentage_approved_for(@german.short).should \
      be_within(0.00001).of(50)
    end

    it "stats should not count translations for other languages" do
      Factory.create(:translation,
                     {:language => @german, :phrase => @phrase1, :approved => true})
      @source.percentage_translated_for(@dutch.short).should \
      be_within(0.00001).of(0)

      @source.percentage_approved_for(@dutch.short).should \
      be_within(0.00001).of(0)
    end

    it "stats should not count multiple translations for one phrase" do
       Factory.create(:translation,
                      {:language => @german, :phrase => @phrase1, :approved => true})
       Factory.create(:translation,
                      {:language => @german, :phrase => @phrase1, :approved => true})
     
      @source.percentage_translated_for(@german.short).should \
      be_within(0.00001).of(50)

      @source.percentage_approved_for(@german.short).should \
      be_within(0.00001).of(50)
    end


    it "stats should count translations of multiple phrases" do
      Factory.create(:translation,
                     {:language => @german, :phrase => @phrase1, :approved => true})
   
      Factory.create(:translation,
                     {:language => @german, :phrase => @phrase2, :approved => true})
      
      @source.percentage_translated_for(@german.short).should \
      be_within(0.00001).of(100)
      @source.percentage_approved_for(@german.short).should \
      be_within(0.00001).of(100)

    end
   
  end
end
