require 'spec_helper'
 	
describe "otwtranslation/languages/_selector.html.erb" do
  it "should display the visible languages" do
    Factory.create(:language, :short => 'en', :name => 'English',
                   :translation_visible => true)
    Factory.create(:language, :short => 'de', :name => 'Deutsch',
                   :translation_visible => true)
    render
    rendered.should contain 'English'
    rendered.should contain 'Deutsch'
  end

  it "should not display the invisible languages" do
    Factory.create(:language, :short => 'en', :name => 'English',
                   :translation_visible => true)
    Factory.create(:language, :short => 'de', :name => 'Deutsch',
                   :translation_visible => false)
    render
    rendered.should contain 'English'
    rendered.should_not contain 'Deutsch'
  end
end
