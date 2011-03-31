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
          flash[:error].should contain 'There was a problem saving the translation'
        end
      
        it "render the new form" do
          post :create, :id => "somekey"
          response.should redirect_to(otwtranslation_new_translation_path("somekey"))
        end
      end

    end
  end
end


describe Otwtranslation::TranslationsController, "POST approve" do

  it "should fail if we are not authenticated" do
    post :approve, :id => 1
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      request.env["HTTP_REFERER"] = "/"
      @translation = mock_model(Otwtranslation::Translation).as_null_object
      Otwtranslation::Translation.stub(:find).and_return(@translation)
    end

    it "should retrieve a translation" do
      Otwtranslation::Translation.should_receive(:find).with(1)
      post :approve, :id => 1
    end

    it "should set translation approved to true" do
      @translation.should_receive(:approved=).with(true)
      post :approve, :id => 1
    end

    it "should save a translation" do
      @translation.should_receive(:save)
      post :approve, :id => 1
    end

    it "should redirect back" do
      post :approve, :id => 1
      response.should redirect_to request.env["HTTP_REFERER"]
    end

    context "when translation fails to save" do

      it "should set a flash[:error] message" do
        @translation.stub(:save).and_return(false)
        post :create, :id => "somekey"
        flash[:error].should contain 'There was a problem saving the translation'
      end
    end
  end
end



describe Otwtranslation::TranslationsController, "GET confirm_disapprove" do

  it "should fail if we are not authenticated" do
    get :confirm_disapprove, :id => 1
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      request.env["HTTP_REFERER"] = "/"
      @translation = mock_model(Otwtranslation::Translation).as_null_object
      Otwtranslation::Translation.stub(:find).and_return(@translation)
    end

    it "should retrieve a translation" do
      Otwtranslation::Translation.should_receive(:find).with(1)
      get :confirm_disapprove, :id => 1
    end

    it "should assign @translation" do
      get :confirm_disapprove, :id => 1
      assigns(:translation).should == @translation
    end

    it "should send me to confirmation page" do
      get :confirm_disapprove, :id => 1
      response.should render_template("otwtranslation/translations/confirm_disapprove")
    end
  end
end


describe Otwtranslation::TranslationsController, "POST disapprove" do

  it "should fail if we are not authenticated" do
    post :disapprove, :id => 1
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      @translation = mock_model(Otwtranslation::Translation).as_null_object
      Otwtranslation::Translation.stub(:find).and_return(@translation)
      @translation.stub(:phrase_key).and_return("somekey")
    end

    it "should retrieve a translation" do
      Otwtranslation::Translation.should_receive(:find).with(1)
      post :disapprove, :id => 1
    end

    it "should set approved to false" do
      @translation.should_receive(:approved=).with(false)
      post :disapprove, :id => 1
    end

    it "should save the translation" do
      @translation.should_receive(:save)
      post :disapprove, :id => 1
    end

    it "should assign @translation" do
      post :disapprove, :id => 1
      assigns(:translation).should == @translation
    end

    it "should send me to the phrase view" do
      post :disapprove, :id => 1
      response.should redirect_to otwtranslation_phrase_path("somekey")
    end

    context "when translation fails to save" do
      
      it "should set flash[:error]" do
        @translation.stub(:save).and_return(false)
        post :disapprove, :id => 1
        flash[:error].should contain 'There was a problem saving the translation'
      end
    end
    
  end
end


describe Otwtranslation::TranslationsController, "GET confirm_destroy" do

  it "should fail if we are not authenticated" do
    get :confirm_destroy, :id => 1
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      request.env["HTTP_REFERER"] = "/"
      @translation = mock_model(Otwtranslation::Translation).as_null_object
      Otwtranslation::Translation.stub(:find).and_return(@translation)
    end

    it "should retrieve a translation" do
      Otwtranslation::Translation.should_receive(:find).with(1)
      get :confirm_destroy, :id => 1
    end

    it "should send me to confirmation page" do
      get :confirm_destroy, :id => 1
      response.should render_template("otwtranslation/translations/confirm_destroy")
    end
  end
end


describe Otwtranslation::TranslationsController, "DELETE destroy" do

  it "should fail if we are not authenticated" do
    delete :destroy, :id => 1
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      @translation = mock_model(Otwtranslation::Translation).as_null_object
      @translation.stub(:phrase_key).and_return("somekey")
      Otwtranslation::Translation.stub(:find).and_return(@translation)
    end

    it "should retrieve a translation" do
      Otwtranslation::Translation.should_receive(:find).with(1)
      delete :destroy, :id => 1
    end

    it "should destroy the translation" do
      @translation.should_receive(:destroy)
      delete :destroy, :id => 1
    end

    it "should send me to the phrase view" do
      delete :destroy, :id => 1
      response.should redirect_to otwtranslation_phrase_path("somekey")
    end    
  end
end

describe Otwtranslation::TranslationsController, "GET show" do

  it "should fail if we are not authenticated" do
    get :show, :id => 1
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      @translation = mock_model(Otwtranslation::Translation).as_null_object
      Otwtranslation::Translation.stub(:find).and_return(@translation)
      @translation.stub(:phrase_key).and_return("somekey")
      
      @phrase = mock_model(Otwtranslation::Phrase)
      Otwtranslation::Phrase.stub(:find_by_key).and_return(@phrase)
    end

    it "should retrieve a translation" do
      Otwtranslation::Translation.should_receive(:find).with(1)
      get :show, :id => 1
    end

    it "should retrieve a phrase" do
      Otwtranslation::Phrase.should_receive(:find_by_key).with("somekey")
      get :show, :id => 1
    end

    it "should assign @translation" do
      post :show, :id => 1
      assigns(:translation).should == @translation
    end

    it "should assign @phrase" do
      post :show, :id => 1
      assigns(:phrase).should == @phrase
    end

    it "should render the show view" do
      get :show, :id => 1
      response.should render_template("otwtranslation/translations/show")
    end    
  end
end


