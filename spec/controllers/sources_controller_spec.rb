require 'spec_helper'
 	
describe Otwtranslation::SourcesController, "GET index" do
  it "should return list of sources" do
    Otwtranslation::Source.should_receive(:all)
    get :index
  end
end

describe Otwtranslation::SourcesController, "GET show" do
  it "should return a source" do
    Otwtranslation::Source.should_receive(:find_by_key).with(1)
    get :show, :id => 1
  end
end
