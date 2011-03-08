require 'spec_helper'
 	
describe Otwtranslation::PhrasesController, "GET index" do
  it "should return list of phrases" do
    Otwtranslation::Phrase.should_receive(:all)
    get :index
  end
end

describe Otwtranslation::PhrasesController, "GET show" do
  it "should return a phrase" do
    Otwtranslation::Phrase.should_receive(:find_by_key).with("somekey")
    get :show, :key => "somekey"
  end
end
