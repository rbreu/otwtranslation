class Otwtranslation::LanguagesController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only, :except => :select


  def index
    @languages = Otwtranslation::Language.all
  end

  def show
    @language = Otwtranslation::Language.find_by_short(params[:id])
  end

  def new
    @language = Otwtranslation::Language.new
  end

  def create
    @language = Otwtranslation::Language.new(params[:otwtranslation_language])

    if @language.save
      flash[:notice] =  ts('Language successfully created.')
      redirect_to otwtranslation_language_path(@language)
    else
      msg = 'There was a problem saving the language:' +
        prettify_error_messages(@language) 
      flash[:error] = msg.html_safe
      render :action => "new"
    end
  end

  
  def select
    session[:otwtranslation_language] = params[:otwtranslation_language]
    redirect_to :back
  end
  
end

