require 'spec_helper'

describe Otwtranslation::TranslationsController, "GET new" do
  
  it "should fail if we are not authenticated" do
    get :new, :id => "somekey"
    response.should_not be_success
  end

  context "when logged in" do

    before(:each) do
      admin_login()
      @phrase = mock_model(Otwtranslation::Phrase).as_null_object
      @translation = mock_model Otwtranslation::Translation
      @translations = mock(Array)
      Otwtranslation::Translation.stub(:new).and_return(@translation)
      Otwtranslation::Phrase.stub(:find_by_key).and_return(@phrase)
      @translation.stub(:phrase_key=)
    end
   
    it "should create a translation for HTML" do
      Otwtranslation::Translation.should_receive(:new)
      @translation.should_receive(:phrase_key=).with("somekey")
      get :new, :id => "somekey"
    end

    it "should create a translation for JS" do
      Otwtranslation::Translation.should_receive(:new)
      @translation.should_receive(:phrase_key=).with("somekey")
      get :new, :id => "somekey", :format => "js"
    end

    it "should assign @phrase for HTML" do
      Otwtranslation::Phrase.should_receive(:find_by_key)
        .with("somekey").and_return @phrase 
      get :new, :id => "somekey"
      assigns[:phrase].should == @phrase
    end
      
    it "should not assign @phrase for JS" do
      Otwtranslation::Phrase.should_not_receive(:find_by_key)
      get :new, :id => "somekey", :format => "js"
      assigns[:phrase].should be_nil
    end
      

    it "should assign @existing_translations for HTML" do
      @phrase.should_receive(:translations).and_return @translations
      @translations.should_receive(:for_language).with(OtwtranslationConfig.DEFAULT_LANGUAGE).and_return []
      get :new, :id => "somekey"
      assigns[:existing_translations].should == []
    end

    it "should not assign @existing_translations for JS" do
      @phrase.should_no_receive(:translations)
      get :new, :id => "somekey", :format => "js"
      assigns[:existing_translations].should be_nil
    end
   
    it "should render new for HTML" do
      get :new, :id => "somekey"
      response.should render_template("new")
    end
      
    it "should render new for JS" do
      get :new, :id => "somekey", :format => "js"
      response.should render_template("new")
    end
      
  end
end


describe Otwtranslation::TranslationsController, "POST create" do
  
  it "should fail if we are not authenticated" do
    post :create, :id => "somekey", :commit => "Add translation"
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      @translation_params = {"language" => "de", "label" => "foreign text",
        "translation_id" => "1"}
      @translation = mock_model(Otwtranslation::Translation).as_null_object
      Otwtranslation::Translation.stub(:new).and_return(@translation)
      @translation2 = mock_model(Otwtranslation::Translation).as_null_object
      Otwtranslation::Translation.stub(:new).and_return(@translation)
      @rule1 = mock_model(Otwtranslation::ContextRule).as_null_object
      @rule2 = mock_model(Otwtranslation::ContextRule).as_null_object
    end

    it "should create a translation for HTML" do
      Otwtranslation::Translation.should_receive(:new)
        .with().and_return(@translation)
      post(:create, :otwtranslation_translation => @translation_params,
           :id => "somekey", :commit => "Add translation")
    end
      
    it "should create a translation for JS" do
      Otwtranslation::Translation.should_receive(:new)
        .with().and_return(@translation)
      post(:create, :otwtranslation_translation => @translation_params,
             :id => "somekey", :format => "js", :commit => "Add translation")
    end

    it "should save a translation for HTML" do
      @translation.should_receive(:save)
      post(:create, :id => "somekey", :commit => "Add translation",
           :otwtranslation_translation => {:label => "a translation"})
    end
      
    it "should save a translation for JS" do
      @translation.should_receive(:save)
      post(:create, :id => "somekey", :format => "js",
           :commit => "Add translation",
           :otwtranslation_translation => {:label => "a translation"})
    end

    it "should assign @translations and @phrase_key for HTML" do
      post(:create, :id => "somekey", :commit => "Add translation",
           :otwtranslation_translation => {:label => "a translation"})
      assigns[:translations].should == [@translation]
      assigns[:phrase_key].should == "somekey"
    end
        
    it "should assign @translations and @phrase_key for JS" do
      post(:create, :id => "somekey", :format => "js",
           :commit => "Add translation",
           :otwtranslation_translation => {:label => "a translation"})
      assigns[:translations].should == [@translation]
      assigns[:phrase_key].should == "somekey"
    end
        

    context "when translation saves successfully" do

      before(:each) do
        @translation.stub(:save).and_return(true)
      end
        
      it "redirects to the newly created translation for HTML" do
        post(:create, :id => "somekey", :commit => "Add translation",
             :otwtranslation_translation => {:label => "a translation"})
        response.should redirect_to(otwtranslation_phrase_path("somekey"))
      end
      
      it "renders create_success for JS" do
        post(:create, :id => "somekey", :format => "js",
             :commit => "Add translation",
             :otwtranslation_translation => {:label => "a translation"})
        response.should render_template("create_success")
      end
      
    end

    context "when translation fails to save" do

      before(:each) do
        @translation.stub(:save).and_return(false)
      end

      it "should set a flash[:error] message for HTML" do
        post(:create, :id => "somekey", :commit => "Add translation",
             :otwtranslation_translation => {:label => "a translation"})
        flash[:error].should contain 'There was a problem saving the translation'
      end
      
      it "should set a flash[:error] message for JS" do
        post(:create, :id => "somekey", :format => "js",
             :commit => "Add translation",
             :otwtranslation_translation => {:label => "a translation"})
        flash[:error].should contain 'There was a problem saving the translation'
      end

      it "should render the new form for HTML" do
        post(:create, :id => "somekey", :commit => "Add translation",
             :otwtranslation_translation => {:label => "a translation"})
        response.should redirect_to(otwtranslation_new_translation_path("somekey"))
      end

      it "should render create_fail for JS" do
        post(:create, :id => "somekey", :format => "js",
             :commit => "Add translation",
             :otwtranslation_translation => {:label => "a translation"})
        response.should render_template("create_fail")
      end
    end
  end
end


describe Otwtranslation::TranslationsController, "POST approve" do

  it "should fail if we are not authenticated" do
    post :approve, :id => '1'
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      request.env["HTTP_REFERER"] = "/"
      @translation = mock_model(Otwtranslation::Translation).as_null_object
      Otwtranslation::Translation.stub(:find).and_return(@translation)
    end


    it "should retrieve a translation for HTML" do
      Otwtranslation::Translation.should_receive(:find).with('1')
      post :approve, :id => '1'
    end
      
    it "should retrieve a translation for JS" do
      Otwtranslation::Translation.should_receive(:find).with('1')
      post :approve, :id => '1', :format => "js"
    end
    
    it "should set translation approved to true for HTML" do
      @translation.should_receive(:approved=).with(true)
      post :approve, :id => '1'
      end
    
    it "should set translation approved to true for JS" do
      @translation.should_receive(:approved=).with(true)
      post :approve, :id => '1', :format => "js"
    end
    
    it "should save a translation for HTML" do
      @translation.should_receive(:save)
      post :approve, :id => '1'
    end
    
    it "should save a translation for JS" do
      @translation.should_receive(:save)
      post :approve, :id => '1', :format => "js"
    end
    
    it "should redirect back for HTML" do
      post :approve, :id => '1'
      response.should redirect_to request.env["HTTP_REFERER"]
    end
    
    it "should render approve for JS" do
      post :approve, :id => '1', :format => "js"
      response.should render_template("approve")
    end
    
    context "when translation fails to save" do

      before(:each) do
        @translation.stub(:save).and_return(false)
      end
      
      it "should set a flash[:error] message for HTML" do
        post :approve, :id => "somekey"
        flash[:error].should contain 'There was a problem saving the translation'
      end

      it "should set a flash[:error] message for JS" do
        post :approve, :id => "somekey", :format => "js"
        flash[:error].should contain 'There was a problem saving the translation'
      end
    end
  end
end



describe Otwtranslation::TranslationsController, "GET confirm_disapprove" do

  it "should fail if we are not authenticated" do
    get :confirm_disapprove, :id => '1'
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      request.env["HTTP_REFERER"] = "/"
      @translation = mock_model(Otwtranslation::Translation).as_null_object
      Otwtranslation::Translation.stub(:find).and_return(@translation)
    end

    it "should assign a translation for HTML" do
      Otwtranslation::Translation.should_receive(:find).with('1')
      get :confirm_disapprove, :id => '1'
      assigns(:translation).should == @translation
    end

    it "should assign a translation_id for JS" do
      get :confirm_disapprove, :id => '1', :format => "js"
      assigns(:translation_id).should == '1'
    end

    it "should render the confirmation page for HTML" do
      get :confirm_disapprove, :id => '1'
      response.should render_template("confirm_disapprove")
    end

    it "should render the confirmation page for JS" do
      get :confirm_disapprove, :id => '1'
      response.should render_template("confirm_disapprove")
    end
  end
end


describe Otwtranslation::TranslationsController, "POST disapprove" do

  it "should fail if we are not authenticated" do
    post :disapprove, :id => '1'
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      @translation = mock_model(Otwtranslation::Translation).as_null_object
      Otwtranslation::Translation.stub(:find).and_return(@translation)
      @translation.stub(:phrase_key).and_return("somekey")
    end

    it "should retrieve a translation for HTML" do
      Otwtranslation::Translation.should_receive(:find).with('1')
      post :disapprove, :id => '1'
    end

    it "should retrieve a translation for JS" do
      Otwtranslation::Translation.should_receive(:find).with('1')
      post :disapprove, :id => '1', :format => "js"
    end

    it "should set approved to false for HTML" do
      @translation.should_receive(:approved=).with(false)
      post :disapprove, :id => '1'
    end

    it "should set approved to false for JS" do
      @translation.should_receive(:approved=).with(false)
      post :disapprove, :id => '1', :format => "js"
    end

    it "should save the translation for HTML" do
      @translation.should_receive(:save)
      post :disapprove, :id => '1'
    end

    it "should save the translation for JS" do
      @translation.should_receive(:save)
      post :disapprove, :id => '1', :format => "js"
    end

    it "should assign @translation for HTML" do
      post :disapprove, :id => '1'
      assigns(:translation).should == @translation
    end

    it "should assign @translation_id for JS" do
      post :disapprove, :id => '1', :format => "js"
      assigns(:translation).should == @translation
    end

    it "should send me to the phrase view for HTML" do
      post :disapprove, :id => '1'
      response.should redirect_to otwtranslation_phrase_path("somekey")
    end

    it "should render disapprove for JS" do
      post :disapprove, :id => '1', :format => "js"
      response.should render_template("dis_approve")
    end

    context "when translation fails to save" do

      before(:each) do
        @translation.stub(:save).and_return(false)
      end

      it "should set flash[:error] for HTML" do
        post :disapprove, :id => '1'
        flash[:error].should contain 'There was a problem saving the translation'
      end

      it "should set flash[:error] for JS" do
        post :disapprove, :id => '1', :format => "js"
        flash[:error].should contain 'There was a problem saving the translation'
      end
    end
  end
end


describe Otwtranslation::TranslationsController, "GET confirm_destroy" do

  it "should fail if we are not authenticated" do
    get :confirm_destroy, :id => '1'
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      request.env["HTTP_REFERER"] = "/"
      @translation = mock_model(Otwtranslation::Translation).as_null_object
      Otwtranslation::Translation.stub(:find).and_return(@translation)
    end

    it "should assign a translation for HTML" do
      Otwtranslation::Translation.should_receive(:find).with('1')
      get :confirm_destroy, :id => '1'
      assigns[:translation].should == @translation
    end

    it "should not assign a translation for JS" do
      Otwtranslation::Translation.should_not_receive(:find)
      get :confirm_destroy, :id => '1', :format => "js"
      assigns[:translation].should be_nil
    end

    it "should assign a translation ID for JS" do
      get :confirm_destroy, :id => '1', :format => "js"
      assigns[:translation_id].should == '1'
    end

    it "should render confirmation page for HTML" do
      get :confirm_destroy, :id => '1'
      response.should render_template("confirm_destroy")
    end

    it "should render confirmation page for JS" do
      get :confirm_destroy, :id => '1'
      response.should render_template("confirm_destroy")
    end
  end
end


describe Otwtranslation::TranslationsController, "DELETE destroy" do

  it "should fail if we are not authenticated" do
    delete :destroy, :id => '1'
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      @translation = mock_model(Otwtranslation::Translation).as_null_object
      @translation.stub(:phrase_key).and_return("somekey")
      Otwtranslation::Translation.stub(:find).and_return(@translation)
    end

    it "should retrieve a translation for HTML" do
      Otwtranslation::Translation.should_receive(:find).with('1')
      delete :destroy, :id => '1'
    end

    it "should retrieve a translation for JS" do
      Otwtranslation::Translation.should_receive(:find).with('1')
      delete :destroy, :id => '1', :format => "js"
    end

    it "should destroy the translation for HTML" do
      @translation.should_receive(:destroy)
      delete :destroy, :id => '1'
    end

    it "should destroy the translation for JS" do
      @translation.should_receive(:destroy)
      delete :destroy, :id => '1', :format => "js"
    end

    it "should send me to the phrase view for HTML" do
      delete :destroy, :id => '1'
      response.should redirect_to otwtranslation_phrase_path("somekey")
    end    

    it "should send me to the phrase view for JS" do
      delete :destroy, :id => '1', :format => "js"
      response.should redirect_to otwtranslation_phrase_path("somekey")
    end    
  end
end

describe Otwtranslation::TranslationsController, "GET show" do

  it "should fail if we are not authenticated" do
    get :show, :id => '1'
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      @translation = mock_model(Otwtranslation::Translation).as_null_object
      Otwtranslation::Translation.stub(:find).and_return(@translation)
      @translation.stub(:phrase_key).and_return("somekey")
      
      @phrase = mock_model(Otwtranslation::Phrase)
      @phrase.stub(:sources).and_return([])
      Otwtranslation::Phrase.stub(:find_by_key).and_return(@phrase)
    end

    it "should retrieve a translation" do
      Otwtranslation::Translation.should_receive(:find).with('1')
      get :show, :id => '1'
    end

    it "should retrieve a phrase" do
      Otwtranslation::Phrase.should_receive(:find_by_key).with("somekey")
      get :show, :id => '1'
    end

    it "should assign @translation" do
      post :show, :id => '1'
      assigns(:translation).should == @translation
    end

    it "should assign @phrase" do
      post :show, :id => '1'
      assigns(:phrase).should == @phrase
    end

    it "should render the show view" do
      get :show, :id => '1'
      response.should render_template("otwtranslation/translations/show")
    end    
  end
end


describe Otwtranslation::TranslationsController, "GET edit" do

  it "should fail if we are not authenticated" do
    get :edit, :id => '1'
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      @phrase = mock_model(Otwtranslation::Phrase).as_null_object
      @translations = mock(Array)
      @translation = mock_model Otwtranslation::Translation
      @translation.stub(:phrase_key).and_return("somekey")
      Otwtranslation::Translation.stub(:find).and_return(@translation)
      Otwtranslation::Phrase.stub(:find_by_key).and_return(@phrase)
    end
   
    it "should receive a translation for HTML" do
      Otwtranslation::Translation.should_receive(:find).with('1')
      get :edit, :id => '1'
    end

    it "should create a translation for JS" do
      Otwtranslation::Translation.should_receive(:find).with('1')
      get :edit, :id => '1', :format => "js"
    end

    it "should assign @phrase for HTML" do
      Otwtranslation::Phrase.should_receive(:find_by_key)
        .with("somekey").and_return @phrase
      get :edit, :id => '1'
      assigns[:phrase].should == @phrase
    end
      
    it "should not assign @phrase for JS" do
      Otwtranslation::Phrase.should_not_receive(:find_by_key)
      get :edit, :id => '1', :format => "js"
      assigns[:phrase].should be_nil
    end
      

    it "should assign @existing_translations for HTML" do
      @phrase.should_receive(:translations).and_return @translations
      @translations.should_receive(:for_language).with(OtwtranslationConfig.DEFAULT_LANGUAGE).and_return []
      get :edit, :id => '1'
      assigns[:existing_translations].should == []
    end

    it "should not assign @existing_translations for JS" do
      @phrase.should_no_receive(:translations)
      get :edit, :id => '1', :format => "js"
      assigns[:existing_translations].should be_nil
    end
   
    it "should render edit for HTML" do
      get :edit, :id => '1'
      response.should render_template("edit")
    end
      
    it "should render edit for JS" do
      get :edit, :id => '1', :format => "js"
      response.should render_template("edit")
    end
  end
end


describe Otwtranslation::TranslationsController, "PUT update" do
  
  it "should fail if we are not authenticated" do
    put :update, :id => "somekey"
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
      @translation = mock_model(Otwtranslation::Translation).as_null_object
      Otwtranslation::Translation.stub(:find).and_return(@translation)
      @translation_params = { :label => "foreign text" }

    end

    it "should retrieve a translation for HTML" do
      Otwtranslation::Translation.should_receive(:find)
        .with('1').and_return(@translation)
      put :update, :otwtranslation_translation => @translation_params, :id => '1'
    end
      
    it "should retrieve a translation for JS" do
      Otwtranslation::Translation.should_receive(:find)
        .with('1').and_return(@translation)
      put :update, :otwtranslation_translation => @translation_params, :id => '1', :format => "js"
    end

    it "should save a translation with new label for HTML" do
      @translation.should_receive(:save)
      @translation.should_receive(:label=).with("foreign text")
      put :update, :otwtranslation_translation => @translation_params, :id => '1'
    end
      
    it "should save a translation with new label for JS" do
      @translation.should_receive(:save)
      @translation.should_receive(:label=).with("foreign text")
      put(:update, :otwtranslation_translation => @translation_params,
          :id => '1', :format => "js")
    end

    it "should assign @translation for HTML" do
      put :update, :otwtranslation_translation => @translation_params, :id => '1'
      assigns[:translation].should == @translation
    end
        
    it "should assign @translation for JS" do
      put(:update, :otwtranslation_translation => @translation_params,
          :id => '1', :format => "js")
      assigns[:translation].should == @translation
    end
        

    context "when translation saves successfully" do

      before(:each) do
        @translation.stub(:save).and_return(true)
      end
        
      it "should redicret to translation page" do
        put :update, :otwtranslation_translation => @translation_params, :id => '1'
        response.should redirect_to otwtranslation_translation_path(@translation)
      end
      
      it "renders edit_success for JS" do
        put(:update, :otwtranslation_translation => @translation_params,
            :id => '1', :format => "js")
        response.should render_template("edit_success")
      end
      
    end

    context "when translation fails to save" do

      before(:each) do
        @translation.stub(:save).and_return(false)
      end

      it "should set a flash[:error] message for HTML" do
        put(:update, :otwtranslation_translation => @translation_params,
            :id => '1')
        flash[:error].should contain 'There was a problem saving the translation'
      end
      
      it "should set a flash[:error] message for JS" do
        put(:update, :otwtranslation_translation => @translation_params,
            :id => '1', :format => "js")
        flash[:error].should contain 'There was a problem saving the translation'
      end

      it "should render the new form for HTML" do
        put(:update, :otwtranslation_translation => @translation_params,
            :id => '1')
        response.should redirect_to(otwtranslation_edit_translation_path('1'))
      end

      it "should render edit_fail for JS" do
        put(:update, :otwtranslation_translation => @translation_params,
            :id => '1', :format => "js")
        response.should render_template("edit_fail")
      end
    end
  end
end


