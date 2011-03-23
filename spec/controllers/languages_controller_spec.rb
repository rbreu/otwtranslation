require 'spec_helper'

describe Otwtranslation::LanguagesController, "GET index" do
  
  it "should fail if we are not authenticated" do
    get :index
    response.should_not be_success
  end

  it "should return list of languages" do
    admin_login()
    languages = mock(Array)
    Otwtranslation::Language.should_receive(:all).and_return(languages)
    get :index
    assigns[:languages].should == languages
  end
end

describe Otwtranslation::LanguagesController, "GET select" do
  before(:each) do
    request.env["HTTP_REFERER"] = "/"
  end
  
  it "should set the language" do
    get :select, :otwtranslation_language => "de"
    session[:otwtranslation_language].should == "de"
  end
  
  it "should overwrite the language" do
    session[:otwtranslation_language] = "en"
    get :select, :otwtranslation_language => "de"
    session[:otwtranslation_language].should == "de"
  end

  it "should redirect back" do
    get :select, :otwtranslation_language => "de"
    response.should redirect_to request.env["HTTP_REFERER"]
  end
  
end
  
describe Otwtranslation::LanguagesController, "GET show" do
  
  it "should fail if we are not authenticated" do
    get :show, :id => 1
    response.should_not be_success
  end

  it "should return a language" do
    admin_login()
    language = mock_model(Otwtranslation::Language)
    Otwtranslation::Language.should_receive(:find_by_short).with(1).and_return(language)
    get :show, :id => 1
    assigns[:language].should == language
   end

end


describe Otwtranslation::LanguagesController, "GET new" do
  
  it "should fail if we are not authenticated" do
    get :new
    response.should_not be_success
  end

  it "should create a language" do
    admin_login()
    Otwtranslation::Language.should_receive(:new)
    get :new
  end
end


describe Otwtranslation::LanguagesController, "POST create" do
  
  it "should fail if we are not authenticated" do
    post :create
    response.should_not be_success
  end

  context "when logged in as admin" do
    
    before(:each) do
      admin_login()
    end

    context "when creating a new language" do

      before(:each) do
        @language_params = {"short" => "de", "name" => "Deutsch",
          "right_to_left" => false, "translation_visible" => true}
        @language = mock_model(Otwtranslation::Language, :save => true)
        Otwtranslation::Language.stub(:new).and_return(@language)
      end
    
      it "should create a language" do
        Otwtranslation::Language.should_receive(:new).with(@language_params).and_return(@language)
        post :create, :otwtranslation_language => @language_params
      end
      
      it "should save a language" do
        @language.should_receive(:save)
        post :create
      end

      context "when language saves successfully" do
      
        before(:each) do
          @language.stub(:save).and_return(true)
        end
        
        it "sets a flash[:notice] message" do
          post :create
          flash[:notice].should == 'Language successfully created.'
        end
      
        it "redirects to the newly created language" do
          post :create
          response.should redirect_to(otwtranslation_language_path(@language))
        end
      end

      context "when language fails to save" do
      
        before(:each) do
          @language.stub(:save).and_return(false)
        end

        it "assigns @language" do
 	  post :create
 	  assigns[:language].should == @language
 	end
        
        it "sets a flash[:error] message" do
          post :create
          flash[:error].should contain 'There was a problem saving the language'
        end
      
        it "render the new form" do
          post :create
          response.should render_template("new")
        end
      end

    end
  end
end
