require 'spec_helper'

describe Otwtranslation::Phrase, "creation" do
  before(:each) do
    Rails.cache.clear
  end
  
  it "should create a new phrase" do
    phrase = Otwtranslation::Phrase.find_or_create("foo")
    phrase.label.should == "foo"
    phrase.description.should == ""
    phrase.locale.should == OtwtranslationConfig.DEFAULT_LOCALE
    phrase.updated_at.should be > 2.seconds.ago
    phrase.is_expired?.should equal false
  end

  it "should create the same phrase only once" do
    phrase1 = Otwtranslation::Phrase.find_or_create("foo")
    phrase2 = Otwtranslation::Phrase.find_or_create("foo")
    phrase1.id.should == phrase2.id
  end

  it "should create two phrases when descriptions differ" do
    phrase1 = Otwtranslation::Phrase.find_or_create("foo", "bar")
    phrase2 = Otwtranslation::Phrase.find_or_create("foo", "baz")
    phrase1.id.should_not == phrase2.id
    phrase1.description.should == "bar"
    phrase2.description.should == "baz"
  end
end

describe Otwtranslation::Phrase, "expiration" do
  before(:each) do
    Rails.cache.clear
    @key, @cache_key = Otwtranslation::Phrase.generate_keys("foo")
    @phrase = Otwtranslation::Phrase.create(:label => "foo", :key => @key)
  end

  it "should not update a phrase that's cached" do
    @phrase.updated_at = 2.minutes.ago
    @phrase.save
    Rails.cache.write(@cache_key, @phrase)
    phrase2 = Otwtranslation::Phrase.find_or_create("foo")
    phrase2.updated_at.should < 1.minutes.ago
  end

  it "should expire cache" do
    @phrase.updated_at = 2.years.ago
    @phrase.save
    OtwtranslationConfig.PHRASE_UPDATE_INTERVAL = '1 second'
    Rails.cache.write(@cache_key, @phrase)
    sleep(2)
    phrase2 = Otwtranslation::Phrase.find_or_create("foo")
    phrase2.updated_at.should < 1.seconds.ago
  end

   it "should update old phrase in DB" do
    @phrase.updated_at = 2.years.ago
    @phrase.save
    OtwtranslationConfig.PHRASE_UPDATE_INTERVAL = '1 second'
    phrase2 = Otwtranslation::Phrase.find_or_create("foo")
    phrase2.updated_at.should > 2.seconds.ago
  end

  it "should expire old phrase" do
    OtwtranslationConfig.PHRASE_EXPIRY_INTERVAL = '1 month'
    @phrase.is_expired?.should equal false
    @phrase.updated_at = 10.years.ago
    @phrase.save
    @phrase.is_expired?.should equal true
  end

end
