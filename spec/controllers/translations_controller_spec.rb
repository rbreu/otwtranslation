require 'spec_helper'

describe Otwtranslation::TranslationsController, "GET new" do
  
  it "should fail if we are not authenticated" do
    get :new
    response.should_not be_success
  end

  it "should create a translation" do
    admin_login()
    Otwtranslation::Translation.should_receive(:new)
    get :new
  end
end


describe Otwtranslation::TranslationController, "POST create" do
  
  it "should fail if we are not authenticated" do
    post :create
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
        @translation = mock_model(Otwtranslation::Translation, :save => nil)
        Otwtranslation::Translation.stub(:new).and_return(@translation)
      end
    
      it "should create a translation" do
        Otwtranslation::Translation.should_receive(:new).with(@translation_params).and_return(@translation)
        post :create, :otwtranslation_translation => @translation_params
      end
      
      it "should save a translation" do
        @translation.should_receive(:save)
        post :create
      end

      context "when translation saves successfully" do
      
        before(:each) do
          @translation.stub(:save).and_return(true)
        end
        
        it "sets a flash[:notice] message" do
          post :create
          flash[:notice].should == 'Translation successfully created.'
        end
      
        it "redirects to the newly created translation" do
          post :create
          response.should redirect_to(otwtranslation_phrase_path(1))
        end
      end

      context "when translation fails to save" do
      
        before(:each) do
          @translation.stub(:save).and_return(false)
        end

        it "assigns @translation" do
 	  post :create
 	  assigns[:translation].should == @translation
 	end
        
        it "sets a flash[:error] message" do
          post :create
          flash[:error].should == 'There was a problem saving the translation.'
        end
      
        it "render the new form" do
          post :create
          response.should render_template("new")
        end
      end

    end
  end
end
