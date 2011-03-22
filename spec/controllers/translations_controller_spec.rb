require 'spec_helper'

describe Otwtranslation::TranslationsController, "GET new" do
  
  it "should fail if we are not authenticated" do
    get :new, :id => "somekey"
    response.should_not be_success
  end

  it "should create a translation" do
    admin_login()
    phrase = mock_model Otwtranslation::Phrase
    Otwtranslation::Translation.should_receive(:new)
    Otwtranslation::Phrase.should_receive(:find_by_key).with("somekey").and_return phrase
    phrase.should_receive(:translations_for).with(OtwtranslationConfig.DEFAULT_LANGUAGE)
    
    get :new, :id => "somekey"
  end
end


describe Otwtranslation::TranslationsController, "POST create" do
  
  it "should fail if we are not authenticated" do
    post :create, :id => "somekey"
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
    end

    context "when creating a new translation" do

      before(:each) do
        @translation_params = {"language" => "de", "label" => "foreign text",
          "translation_id" => "1"}
        @translation = mock_model(Otwtranslation::Translation).as_null_object
        Otwtranslation::Translation.stub(:new).and_return(@translation)
      end
    
      it "should create a translation" do
        Otwtranslation::Translation.should_receive(:new).with(@translation_params).and_return(@translation)
        post(:create, :otwtranslation_translation => @translation_params,
             :id => "somekey")
      end
      
      it "should save a translation" do
        @translation.should_receive(:save)
        post :create, :id => "somekey"
      end

      context "when translation saves successfully" do
      
        before(:each) do
          @translation.stub(:save).and_return(true)
        end
        
        it "sets a flash[:notice] message" do
          post :create, :id => "somekey"
          flash[:notice].should == 'Translation successfully created.'
        end
      
        it "redirects to the newly created translation" do
          post :create, :id => "somekey"
          response.should redirect_to(otwtranslation_phrase_path("somekey"))
        end
      end

      context "when translation fails to save" do
      
        before(:each) do
          @translation.stub(:save).and_return(false)
        end

        it "assigns @translation" do
 	  post :create, :id => "somekey"
 	  assigns[:translation].should == @translation
 	end
        
        it "sets a flash[:error] message" do
          post :create, :id => "somekey"
          flash[:error].should == 'There was a problem saving the translation.'
        end
      
        it "render the new form" do
          post :create, :id => "somekey"
          response.should redirect_to(otwtranslation_new_translation_path("somekey"))
        end
      end

    end
  end
end
