require 'spec_helper'
 	
describe "otwtranslation/languages/_selector" do

  context "when there are visible and invisible languages" do
    before(:each) do
      FactoryGirl.create(:language, :name => 'English',
                         :translation_visible => true)
      FactoryGirl.create(:language, :name => 'Deutsch',
                         :translation_visible => true)
      FactoryGirl.create(:language, :name => 'Nederlands',
                         :translation_visible => false)
    end

    context "when translation tools not visible" do
      before(:each) do
        view.stub(:otwtranslation_tool_visible?).and_return(false)
      end
      
      it "should display the visible languages" do
        render
        rendered.should contain 'English'
        rendered.should contain 'Deutsch'
      end
      
      it "should not display the invisible languages" do
        render
        rendered.should_not contain 'Nederlands'
      end

    end
    
    it "should show all languages when translation tools are visible" do
      view.stub(:otwtranslation_tool_visible?).and_return(true)
      render
      rendered.should contain 'Nederlands'
    end
  end
end
