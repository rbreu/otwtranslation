# -*- coding: utf-8 -*-
require 'spec_helper'

describe OtwtranslationHelper, "ts" do

  it "should return the original phrase" do
    helper.ts("Foo Bar!").should == "Foo Bar!"
  end
  
  it "should substitute tokens" do
    helper.ts("Hello {data::name}!", :name => "Abby")
      .should == "Hello Abby!"
  end
  
  it "should save descriptions" do
    ts("Bar Baz!", :_description => "foo")
    Otwtranslation::Phrase.last.description.should == "foo"
  end
  
end

describe OtwtranslationHelper, "t" do
  it "should return the original phrase" do
    t("home.greeting", :default => "Deprecated!").should == "Deprecated!"
  end
  
  it "should insert variables" do
    t("home.greeting", :default => "Deprecated, %{name}!",
      :name => "Abby").should == "Deprecated, Abby!"
  end
end


describe OtwtranslationHelper, "otwtranslation_decorated_translation" do
  before(:each) do
    @phrase = FactoryGirl.create(:phrase, :label => "Good day!")
    @language = FactoryGirl.create(:language, :name => "Deutsch")
    helper.stub(:params){{'locale' => @language.locale}}
  end
  
  it "should mark the phrase untranslated" do
      helper.otwtranslation_decorated_translation(@phrase.key, @phrase.label)
      .should == "<span id=\"otwtranslation_phrase_#{@phrase.key}\" class=\"untranslated\"><span class=\"landmark\">translate</span>*Good day!</span>"
  end
  
  it "should mark the phrase untranslated for decorate_off" do
    helper.otwtranslation_decorated_translation(@phrase.key, @phrase.label,
                                         :_decorate_off => true)
      .should == "*Good day!"
  end
      
  it "should work when called without label and variables" do
    helper.otwtranslation_decorated_translation(@phrase.key)
      .should == "<span id=\"otwtranslation_phrase_#{@phrase.key}\" class=\"untranslated\"><span class=\"landmark\">translate</span>*Good day!</span>"
    
    @phrase = FactoryGirl.create(:phrase, :label => "Hi {general::name}!")
    helper.otwtranslation_decorated_translation(@phrase.key)
      .should == "<span id=\"otwtranslation_phrase_#{@phrase.key}\" class=\"untranslated\"><span class=\"landmark\">translate</span>*Hi {general::name}!</span>"
  end
  
  it "should mark the phrase translated" do
    translation = FactoryGirl.create(:translation,
                                     :label => "Guten Tag!",
                                     :language => @language,
                                     :approved => false,
                                     :phrase => @phrase)
    
    helper.otwtranslation_decorated_translation(@phrase.key, @phrase.label)
      .should == "<span id=\"otwtranslation_phrase_#{@phrase.key}\" class=\"translated\"><span class=\"landmark\">review</span>*Guten Tag!</span>"
    
  end
  
  it "should mark the phrase translated for decorate_off" do
    translation = FactoryGirl.create(:translation,
                                     :label => "Guten Tag!",
                                     :language => @language,
                                     :approved => false,
                                     :phrase => @phrase)
    
    helper.otwtranslation_decorated_translation(@phrase.key, @phrase.label,
                                                :_decorate_off => true)
      .should == "*Guten Tag!"
    
  end
    
  it "should mark the phrase approved" do
    translation = FactoryGirl.create(:translation,
                                     :label => "Moin!",
                                     :language => @language,
                                     :approved => true,
                                     :phrase => @phrase)
    
    helper.otwtranslation_decorated_translation(@phrase.key, @phrase.label)
      .should == "<span id=\"otwtranslation_phrase_#{@phrase.key}\" class=\"approved\">Moin!</span>"
    end
  
  it "should mark the phrase approved for decorate_off" do
    translation = FactoryGirl.create(:translation,
                                     :label => "Moin!",
                                     :language => @language,
                                     :approved => true,
                                     :phrase => @phrase)
    
    helper.otwtranslation_decorated_translation(@phrase.key, @phrase.label,
                                                :_decorate_off => true)
      .should == "Moin!"
  end
  
  it "should cache all text labels" do
    t = otwtranslation_decorated_translation(@phrase.key, @phrase.label)
    Otwtranslation::Phrase.should_not_receive(:find_by_key)
    t.should == "<span id=\"otwtranslation_phrase_#{@phrase.key}\" class=\"untranslated\"><span class=\"landmark\">translate</span>*Good day!</span>"
  end
  
end



describe OtwtranslationHelper, "otwtranslation_translation" do
  before(:each) do
    @phrase = FactoryGirl.create(:phrase, :label => "Greetings!")
    @phrase2 = FactoryGirl.create(:phrase, :label => "{possessive::foo}")
    @de = FactoryGirl.create(:language, :name => "Deutsch")
    @en = FactoryGirl.create(:language, :name => "English")
    helper.stub(:params){{'locale' => @de.locale}}

    @rule_de = FactoryGirl.create(:possessive_rule, :language => @de,
                                  :conditions => [["matches all", []]],
                                  :actions => [["append", ["DE"]]])
    @rule_en = FactoryGirl.create(:possessive_rule, :language => @en,
                                  :conditions => [["matches all", []]],
                                  :actions => [["append", ["EN"]]])
  end
  
  it "should return original phrase when no translation exists" do
    helper.otwtranslation_translation(@phrase.key, @phrase.label, {})
      .should == "Greetings!"
  end
  
  it "should return approved translation" do
    FactoryGirl.create(:translation,
                       :label => "Grüße!",
                       :language => @de,
                       :approved => true,
                       :phrase => @phrase)

    helper.otwtranslation_translation(@phrase.key, @phrase.label, {})
      .should == "Grüße!"
  end
  
  it "should not return unapproved translation" do
    FactoryGirl.create(:translation,
                       :label => "Grüße!",
                       :language => @de,
                       :approved => false,
                       :phrase => @phrase)

    helper.otwtranslation_translation(@phrase.key, @phrase.label, {})
      .should == "Greetings!"
  end

  it "should apply english rules when no translation exists" do
    otwtranslation_translation(@phrase2.key, @phrase2.label, {:foo => "bar"})
      .should == "barEN"
  end
  
  it "should apply german rules when translation exists" do
    FactoryGirl.create(:translation,
                       :label => "{possessive::foo}",
                       :language => @de,
                       :approved => true,
                       :phrase => @phrase2,
                       :rules => [@rule_de.id])
    
    helper.otwtranslation_translation(@phrase2.key, @phrase2.label, 
                                      {:foo => "bar"})
      .should == "barDE"
  end
  
end


describe OtwtranslationHelper, "otwtranslation_language_selector" do
  before(:each) do
    helper.stub(:url_for){ "" }
    @de = FactoryGirl.create(:language, :name => "Deutsch",
                             :translation_visible => false)
    @nl = FactoryGirl.create(:language, :name => "Nederlands")
    @en = FactoryGirl.create(:language, :name => "English")
  end
  
  it "should list visible languages for not-authenticated users" do
    helper.stub(:current_user){ nil }
    ret = helper.otwtranslation_language_selector()
    ret.should contain "English"
    ret.should contain "Nederlands"
    ret.should_not contain "Deutsch"
  end

  it "should list visible languages for ordinary users" do
    user = FactoryGirl.create(:user)
    helper.stub(:current_user){ FactoryGirl.create(:user) }
    ret = helper.otwtranslation_language_selector()
    ret.should contain "English"
    ret.should contain "Nederlands"
    ret.should_not contain "Deutsch"
  end

  it "should list visible languages for translators" do
    user = FactoryGirl.create(:user)
    helper.stub(:current_user){ FactoryGirl.create(:user,
                                                   :translation_admin => true) }
    ret = helper.otwtranslation_language_selector()
    ret.should contain "English"
    ret.should contain "Nederlands"
    ret.should contain "Deutsch"
  end
end
