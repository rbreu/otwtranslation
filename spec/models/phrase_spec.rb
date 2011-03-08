require 'spec_helper'

describe Otwtranslation::Phrase do
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

  # The exact time limits depend on the configuration, but using the
  # config values makes the tests really ugly. Let's hope no-one
  # changes the default config to so unreasonable values that the
  # following tests fail...
  
  it "should not update a newish phrase" do
    phrase1 = Otwtranslation::Phrase.find_or_create("foo")
    phrase1.updated_at = 2.minutes.ago
    phrase1.save
    phrase2 = Otwtranslation::Phrase.find_or_create("foo")
    phrase2.updated_at.should < 1.minutes.ago
  end

  it "should update old phrase" do
    phrase1 = Otwtranslation::Phrase.find_or_create("foo")
    phrase1.updated_at = 2.years.ago
    phrase1.save
    phrase2 = Otwtranslation::Phrase.find_or_create("foo")
    phrase2.updated_at.should > 2.seconds.ago
  end

  it "should expire old phrase" do
    phrase = Otwtranslation::Phrase.find_or_create("foo")
    phrase.is_expired?.should equal false
    phrase.updated_at = 10.years.ago
    phrase.save
    phrase.is_expired?.should equal true
  end

end
