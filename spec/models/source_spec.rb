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
    source.has_phrases_with_current_version?.should be_true
  end
  
  it "should return false when there are no phrases with current version" do
    OtwtranslationConfig.VERSION = '1.0'
    source = {:controller => "test", :action => "me"}
    phrase = Otwtranslation::Phrase.find_or_create("Hello", "", source)
    OtwtranslationConfig.VERSION = '1.1'

    source = Otwtranslation::Source.find_by_source(source)
    source.has_phrases_with_current_version?.should be_false
  end

  it "should return true when there are new phrases" do
    OtwtranslationConfig.VERSION = '1.0'
    source = {:controller => "test", :action => "me"}
    phrase = Otwtranslation::Phrase.find_or_create("Hello", "", source)

    source = Otwtranslation::Source.find_by_source(source)
    source.has_new_phrases?.should be_true
  end
  
  it "should return false when there are no new phrases" do
    OtwtranslationConfig.VERSION = '1.0'
    source = {:controller => "test", :action => "me"}
    phrase = Otwtranslation::Phrase.find_or_create("Hello", "", source)
    OtwtranslationConfig.VERSION = '1.1'
    phrase = Otwtranslation::Phrase.find_or_create("Hello", "", source)

    source = Otwtranslation::Source.find_by_source(source)
    source.has_new_phrases?.should be_false
  end
  

  context "when there are languages, phrases and sources" do

    before(:each) do
      @german = FactoryGirl.create(:language, :name => "Deutsch")
      @dutch = FactoryGirl.create(:language, :name => "Nederlands")
      
      @source = FactoryGirl.create(:source)
      
      @phrase1 = FactoryGirl.create(:phrase)
      @phrase1.sources << @source
      @phrase2 = FactoryGirl.create(:phrase)
      @phrase2.sources << @source
    end
    
    it "stats should return 0% for 0 translations" do
      @source.percentage_translated_for(@german.short).should \
      be_within(0.00001).of(0)

      @source.percentage_approved_for(@german.short).should \
      be_within(0.00001).of(0)
    end

    it "stats should count translations in the current language" do
      FactoryGirl.create(:translation,
                         {:language => @german, :phrase => @phrase1})
      @source.percentage_translated_for(@german.short).should \
      be_within(0.00001).of(50)

      @source.percentage_approved_for(@german.short).should \
      be_within(0.00001).of(0)
    end
    
    it "stats should count approved translations in the current language" do
      FactoryGirl.create(:translation,
                         {:language => @german, :phrase => @phrase1, 
                           :approved => true})
      @source.percentage_translated_for(@german.short).should \
      be_within(0.00001).of(50)

      @source.percentage_approved_for(@german.short).should \
      be_within(0.00001).of(50)
    end

    it "stats should not count translations for other languages" do
      FactoryGirl.create(:translation,
                         {:language => @german, :phrase => @phrase1,
                           :approved => true})
      @source.percentage_translated_for(@dutch.short).should \
      be_within(0.00001).of(0)

      @source.percentage_approved_for(@dutch.short).should \
      be_within(0.00001).of(0)
    end

    it "stats should not count multiple translations for one phrase" do
      FactoryGirl.create(:translation,
                         {:language => @german, :phrase => @phrase1,
                           :approved => true})
      FactoryGirl.create(:translation,
                         {:language => @german, :phrase => @phrase1})
     
      @source.percentage_translated_for(@german.short).should \
      be_within(0.00001).of(50)

      @source.percentage_approved_for(@german.short).should \
      be_within(0.00001).of(50)
    end


    it "stats should count translations of multiple phrases" do
      FactoryGirl.create(:translation,
                         {:language => @german, :phrase => @phrase1,
                           :approved => true})
   
      FactoryGirl.create(:translation,
                         {:language => @german, :phrase => @phrase2,
                           :approved => true})
      
      @source.percentage_translated_for(@german.short).should \
      be_within(0.00001).of(100)
      @source.percentage_approved_for(@german.short).should \
      be_within(0.00001).of(100)

    end
   
  end
end
